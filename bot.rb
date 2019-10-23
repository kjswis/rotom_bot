require 'bundler'
require 'erb'
require 'yaml'
require 'json'
require 'terminal-table'

BOT_ENV = ENV.fetch('BOT_ENV') { 'development' }
Bundler.require(:default, BOT_ENV)

require 'active_record'

# Constants: such as roles and channel ids

ADMINS = 308250685554556930

# ---

Dotenv.load if BOT_ENV != 'production'

db_yml = File.open('config/database.yml') do |erb|
  ERB.new(erb.read).result
end

db_config = YAML.safe_load(db_yml)[BOT_ENV]
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: db_config.fetch('host') { 'localhost' },
  database: db_config['database'],
  user: db_config['user'],
  password: db_config['password']
)

Dir['app/**/*.rb'].each { |f| require File.join(File.expand_path(__dir__), f) }
Dir['/lib/*.rb'].each { |f| require f }


token = ENV['DISCORD_BOT_TOKEN']
bot = Discordrb::Bot.new(token: token)

# Methods: define basic methods here
# ---

# Commands: structure basic bot commands here
commands = []
pm_commands = []

hello = Command.new(:hello, "Says hello!") do |event|
  user = event.author.nickname || event.author.name

  greetings = [
    "Hi there, #{user}",
    "Greetings #{user}, you lovable bum",
    "Alola, #{user}",
    "Hello, #{user}! The Guildmasters have been waiting",
    "#{user} would like to battle!"
  ]

  Embed.new(
    description: greetings.sample,
    color: event.author.color.combined,
    thumbnail: {
      url: Image::HAPPY
    }
  )
end

opts = {
  "" => "displays a list of all commands",
  "command" => "displays info and usage for specified command"
}
desc = "Displays help information for the commands"
help = Command.new(:help, desc, opts) do |event, command|
  if command
    short = /pkmn-(\w+)/.match(command)
    command = short ? short[1] : command
    cmd = commands.detect { |c| c.name == command.to_sym }
    pm_cmd = pm_commands.detect { |pc| pc.name == command.to_sym }
  end

  if command && cmd
    command_embed(cmd)
  elsif command && pm_cmd
    command_embed(pm_cmd, "PM Command")
  elsif !command
    embed = command_list_embed(
      pm_commands,
      "Can only be used in a pm with the bot",
      "PM Commands"
    )

    event.send_embed("", embed)
    command_list_embed(commands)
  else
    command_error_embed("Command not found!", help)
  end
end

opts = { "type" => "" }
desc = "Displays a chart of effectiveness for the given type"
matchup = Command.new(:matchup, desc, opts) do |event, type|
  channel = event.channel.id
  file = "images/Type #{type.capitalize}.png"

  if File.exists?(file)
    bot.send_file(channel, File.open(file, 'r'))
  else
    bot.respond("I do not know this pokemon type! Please try again!")
  end
end

opts = {
  "" => "starts a new app",
  "name" => "edits an existing app",
  "name | (in)active" => "sets app to active or inactive"
}
desc = "Everything to do with character applications"
app = Command.new(:app, desc, opts) do |event, name, status|
  user = event.author
  user_name = user.nickname || user.name
  color = user.color ? user.color.combined : Color::DEFAULT

  character = Character.where(user_id: user.id).find_by(name: name) if name
  active = status.match(/(in)?active/i) if status

  case
  when name && !character
    app_not_found_embed(user_name, name)

  when status && active && character
    character.update!(active: active[0].capitalize)
    character.reload

    success_embed("Successfully updated #{name} to be #{active[0].downcase}")
  when name && character && !status
    edit_url = Url::CHARACTER + character.edit_url
    embed = edit_app_dm(name, edit_url, color)

    bot.send_message(user.dm.id, "", false, embed)
    edit_app_embed(user_name, name, color)
  when !name && !status
    embed = new_app_dm(user_name, color, user.id)

    message = bot.send_message(user.dm.id, "", false, embed)
    message.react(Emoji::PHONE)

    new_app_embed(user_name, color)
  else
    command_error_embed("There was an error processing your application!", app)
  end
end

opts = { "question | option1, option2, etc" => ""}
desc = "Creates a dynamic poll in any channel"
poll = Command.new(:poll, desc, opts) do |event, question, options|
  if options
    options_array = options.split(/\s?,\s?/)
    new_poll_embed(event, question, options_array)
  else
    command_error_embed("There was an error creating your poll!", poll)
  end
end

opts = {
  "participants" =>
  "Accepts Everyone, Here, or a comma seperated list of names"
}
desc = "Creates a raffle and picks a winner"
raffle = Command.new(:raffle, desc, opts) do |event, participant|
  participants =
    case participant
    when /^everyone$/i
      event.server.members
    when /^here$/i
      event.message.channel.users
    else
      participant.split(/\s?,\s?/)
    end

  winner = participants.sample
  winner_name =
    case winner
    when String
      winner
    else
      winner.nickname || winner.username
    end

    if winner_name
      message_embed("Raffle Results!", "Winner: #{winner_name}")
    else
      command_error_embed("There was an error creating your raffle!", raffle)
    end
end

opts = {
  "name | keyword | (n)sfw | url" => "add or update image",
  "name | keyword | delete" => "remove image",
  "name | keyword" => "display image",
  "name" => "list all images"
}
desc = "View, add and edit your characters' images"
image = Command.new(:image, desc, opts) do |event, name, keyword, tag, url|
  user = event.author

  char = Character.where(user_id: user.id).find_by!(name: name) if name
  color = CharacterController.type_color(char) if char
  img = CharImage.find_by(keyword: keyword) if keyword

  case
  when /^Default$/i.match(keyword)
    error_embed(
      "Cannot update Default here!",
      "Use `pkmn-app character` to edit your default image in your form"
    )
  when char && keyword && url && tag && tag.match(/(n)?sfw/i)
    img_app = CharImage.to_form(
      char.name,
      char.species,
      char.id,
      keyword,
      tag,
      url,
      user.id
    )

    approval = bot.send_message(Channel::APPROVAL, img_app, false, nil)
    approval.react(Emoji::Y)
    approval.react(Emoji::N)

    success_embed("Your image has been submitted for approval!")
  when char && img && tag && tag.match(/delete/i)
    CharImage.find(img.id).delete
    success_embed("Removed image: #{keyword}")
  when char && img && !tag
    char_image_embed(char, img, user, color)
  when char && !keyword
    imgs = CharImage.where(char_id: char.id)
    image_list_embed(char, imgs, user, color)
  when keyword && !img
    error_embed("Could not find your image!")
  else
    command_error_embed("Could not process your image request!", image)
  end

rescue ActiveRecord::RecordNotFound
  error_embed(
    "Character not Found!",
    "I could not find your character named #{name}"
  )
end

opts = {
  "" => "List all guild members",
  "@user" => "List all characters belonging to the user",
  "name " => "Display the given character",
  "name | section" => "Display the given section for the character",
  "name | image | keword" => "Display the given image"
}
desc = "Display info about the guild members"
member = Command.new(:member, desc, opts) do |event, name, section, keyword|
  sections = [:all, :default, :bio, :type, :status, :rumors, :image]

  case name
  when Regex::UID
    user_id = Regex::UID.match(name)
  when String
    chars = Character.where(name: name)
    char = chars.first if chars.length == 1

    if char
      img = CharImage.where(char_id: char.id).find_by(keyword: 'Default')
      user = event.server.member(char.user_id)
      color = CharacterController.type_color(char)
    end
  end

  case
  when !name
    chars = Character.all
    char_list_embed(chars)
  when name && user_id
    chars = Character.where(user_id: user_id[1])
    user = event.server.member(user_id[1])
    chars_id = []

    chars.each do |char|
      chars_id.push char.id if char.active == 'Active'
    end

    embed = user_char_embed(chars, user)
    msg = event.send_embed("", embed)

    Carousel.create(message_id: msg.id, options: chars_id)
    option_react(msg, chars_id)
  when name && chars && !char
    embed = dup_char_embed(chars, name)
    chars_id = chars.map(&:id)

    msg = event.send_embed("", embed)
    Carousel.create(message_id: msg.id, options: chars_id)

    option_react(msg, chars_id)
  when name && char && !section
    embed = character_embed(
      char: char,
      img: img,
      section: :default,
      user: user,
      color: color
    )

    msg = event.send_embed("", embed)
    Carousel.create(message_id: msg.id, char_id: char.id)

    section_react(msg)
  when char && section && keyword
    embed = command_error_embed(
      "Invalid Arguments",
      member
    )unless /image/i.match(section)

    unless embed
      img = CharImage.where(char_id: char.id).find_by!(keyword: keyword)

      embed = error_embed(
        "Wrong Channel!",
        "The requested image is NSFW"
      )if img.category == 'NSFW' && !event.channel.nsfw?
    end

    unless embed
      embed = character_embed(
        char: char,
        img: img,
        section: :image,
        user: user,
        color: color
      )

      msg = event.send_embed("", embed)
      Carousel.create(message_id: msg.id, char_id: char.id, image_id: img.id)

      arrow_react(msg)
    end

    embed
  when name && char && section
    sect = section.downcase.to_sym
    nsfw = event.channel.nsfw?

    img = ImageController.img_scroll(
      char_id: char.id,
      nsfw: nsfw
    )if section == :image

    if sections.detect{ |s| s == sect }
      embed = character_embed(
        char: char,
        img: img,
        section: sect,
        user: user,
        color: color,
      )

      msg = event.send_embed("", embed)
      Carousel.create(message_id: msg.id, char_id: char.id, image_id: img.id)

      if sect == :image
        arrow_react(msg)
      else
        section_react(msg)
      end
    else
      error_embed("Invalid Section!")
    end
  end


rescue ActiveRecord::RecordNotFound => e
  error_embed("Record Not Found!", e.message)
end

# ---

commands = [
  hello,
  matchup,
  app,
  help,
  poll,
  raffle,
  member
]

# This will trigger on every message sent in discord
bot.message do |event|
  content = event.message.content
  author = event.author.id

  command = /^pkmn-(\w+)/.match(content)
  cmd = commands.detect { |c| c.name == command[1].to_sym } if command

  reply = cmd.call(content, event) if cmd

  case reply
  when Embed
    event.send_embed("", reply)
  when String
    event.respond(reply)
  end

  event.send_embed(
    "",
    error_embed("Command not found!")
  )if command && !cmd && event.server

  Character.check_user(event) if author == Bot::CHARACTER
end

pm_commands = [ image ]

# This will trigger when a dm is sent to the bot from a user
bot.pm do |event|
  content = event.message.content

  command = /^pkmn-(\w+)/.match(content)
  cmd = pm_commands.detect { |c| c.name == command[1].to_sym } if command

  reply = cmd.call(content, event) if cmd

  case reply
  when Embed
    event.send_embed("", reply)
  when String
    event.respond(reply)
  end
end

# This will trigger when any reaction is added in discord
bot.reaction_add do |event|
  content = event.message.content
  reactions = event.message.reactions

  maj = if event.server
          event.server.roles.find{ |r| r.id == ADMINS }.members.count / 2
        end
  maj = 1

  form =
    case
    when event.message.author.id == Bot::CHARACTER
      :character_application
    when event.message.from_bot? && content.match(Regex::CHAR_APP)
      :character_rejection
    when event.message.from_bot? && event.server.nil?
      :pm
    when event.message.from_bot? && content.match(/\_New\sCharacter\sImage\_:/)
      :image_application
    when carousel = Carousel.find_by(message_id: event.message.id)
      :carousel
    end

  vote =
    case
    when reactions[Emoji::Y]&.count.to_i > maj then :yes
    when reactions[Emoji::N]&.count.to_i > maj then :no
    when reactions[Emoji::CHECK]&.count.to_i > 1 then :check
    when reactions[Emoji::CROSS]&.count.to_i > 1 then :cross
    when reactions[Emoji::CRAYON]&.count.to_i > 1 then :crayon
    when reactions[Emoji::NOTEBOOK]&.count.to_i > 1 then :notebook
    when reactions[Emoji::QUESTION]&.count.to_i > 1 then :question
    when reactions[Emoji::PALLET]&.count.to_i > 1 then :pallet
    when reactions[Emoji::EAR]&.count.to_i > 1 then :ear
    when reactions[Emoji::PICTURE]&.count.to_i > 1 then :picture
    when reactions[Emoji::BAGS]&.count.to_i > 1 then :bags
    when reactions[Emoji::FAMILY]&.count.to_i > 1 then :family
    when reactions[Emoji::EYES]&.count.to_i > 1 then :eyes
    when reactions[Emoji::KEY]&.count.to_i > 1 then :key
    when reactions[Emoji::PHONE]&.count.to_i > 1 then :phone
    when reactions[Emoji::LEFT]&.count.to_i > 1 then :left
    when reactions[Emoji::RIGHT]&.count.to_i > 1 then :right
    when reactions[Emoji::UNDO]&.count.to_i > 1 then :back
    when reactions.any? { |k,v| Emoji::NUMBERS.include? k } then :number
    end

  case [form, vote]
  when [:character_application, :yes]
    params = content.split("\n")
    uid = Regex::UID.match(content)
    user = event.server.member(uid[1])

    char = CharacterController.edit_character(params)
    img = ImageController.default_image(content, char.id)
    color = CharacterController.type_color(char)

    embed = character_embed(
      char: char,
      img: img,
      user: user,
      color: color
    )if char

    if embed
      bot.send_message(
        Channel::CHARACTER,
        "Good news, <@#{user.id}>! Your character was approved",
        false,
        embed
      )
      event.message.delete
    else
      event.respond(
        "",
        admin_error_embed("Something went wrong when saving application")
      )
    end
  when [:character_application, :no]
    content = event.message.content
    embed = reject_char_embed(content)

    event.message.delete
    reject = event.send_embed(content, embed)

    Emoji::CHAR_APP.each do |reaction|
      reject.react(reaction)
    end

    reject.react(Emoji::CHECK)
    reject.react(Emoji::CROSS)
    reject.react(Emoji::CRAYON)

  when [:character_rejection, :check]
    user = event.server.member(Regex::UID.match(content)[1])
    embed = user_char_app(event)

    event.message.delete
    bot.send_temporary_message(event.channel.id, "", 5, false, embed)
    bot.send_message(user.dm.id, "", false, embed)
  when [:character_rejection, :cross]
    event.message.delete

  when [:character_rejection, :crayon]
    event.message.delete
    bot.send_temporary_message(
      event.channel.id,
      "",
      35,
      false,
      self_edit_embed(content)
    )

  when [:pm, :phone]
    event.message.delete_own_reaction(Emoji::PHONE)
    user = event.message.reacted_with(Emoji::PHONE).first

    bot.send_message(user.dm.id, user.id, false, nil)
  when [:image_application, :yes]
    params = content.split("\n")
    img = ImageController.edit_image(params)

    char = Character.find(img.char_id)
    user = event.server.member(char.user_id)
    color = CharacterController.type_color(char)

    embed = char_image_embed(char, img, user, color)

    event.message.delete if embed
    channel = if img.category == 'SFW'
                Channel::CHARACTER
              else
                Channel::CHARACTER_NSFW
              end
    bot.send_message(channel, "Image Approved!", false, embed)
  when [:image_application, :no]
    content = event.message.content
    embed = reject_img_embed(content)

    event.message.delete
    reject = event.send_embed(content, embed)

    Emoji::IMG_APP.each do |reaction|
      reject.react(reaction)
    end

    reject.react(Emoji::CHECK)
    reject.react(Emoji::CROSS)

  when [:image_application, :check]
    user = event.server.member(Regex::UID.match(content)[1])
    embed = user_img_app(event)

    event.message.delete
    bot.send_temporary_message(event.channel.id, "", 5, false, embed)
    bot.send_message(user.dm.id, "", false, embed)
  when [:image_application, :cross]
    event.message.delete

  when [:carousel, :notebook]
    emoji = Emoji::NOTEBOOK
    users = event.message.reacted_with(emoji)

    users.each do |user|
      event.message.delete_reaction(user.id, emoji) unless user.current_bot?
    end

    char = Character.find(carousel.char_id)
    embed = character_embed(
      char: char,
      img: CharImage.where(char_id: char.id).find_by(keyword: 'Default'),
      user: event.server.member(char.user_id),
      color: CharacterController.type_color(char),
      section: :bio
    )
    event.message.edit("", embed)
  when [:carousel, :question]
    emoji = Emoji::QUESTION
    users = event.message.reacted_with(emoji)

    users.each do |user|
      event.message.delete_reaction(user.id, emoji) unless user.current_bot?
    end

    char = Character.find(carousel.char_id)
    embed = character_embed(
      char: char,
      img: CharImage.where(char_id: char.id).find_by(keyword: 'Default'),
      user: event.server.member(char.user_id),
      color: CharacterController.type_color(char),
      section: :status
    )
    event.message.edit("", embed)
  when [:carousel, :pallet]
    emoji = Emoji::PALLET
    users = event.message.reacted_with(emoji)

    users.each do |user|
      event.message.delete_reaction(user.id, emoji) unless user.current_bot?
    end

    char = Character.find(carousel.char_id)
    embed = character_embed(
      char: char,
      img: CharImage.where(char_id: char.id).find_by(keyword: 'Default'),
      user: event.server.member(char.user_id),
      color: CharacterController.type_color(char),
      section: :type
    )
    event.message.edit("", embed)
  when [:carousel, :ear]
    emoji = Emoji::EAR
    users = event.message.reacted_with(emoji)

    users.each do |user|
      event.message.delete_reaction(user.id, emoji) unless user.current_bot?
    end

    char = Character.find(carousel.char_id)
    embed = character_embed(
      char: char,
      img: CharImage.where(char_id: char.id).find_by(keyword: 'Default'),
      user: event.server.member(char.user_id),
      color: CharacterController.type_color(char),
      section: :rumors
    )
    event.message.edit("", embed)
  when [:carousel, :picture]
    event.message.delete_all_reactions

    char = Character.find(carousel.char_id)
    img = ImageController.img_scroll(
      char_id: char.id,
      nsfw: event.channel.nsfw?,
    )
    carousel.update(id: carousel.id, image_id: img.id)

    embed = character_embed(
      char: char,
      img: img,
      user: event.server.member(char.user_id),
      color: CharacterController.type_color(char),
      section: :image
    )
    event.message.edit("", embed)
    arrow_react(event.message)
  when [:carousel, :bags]
  when [:carousel, :family]
  when [:carousel, :eyes]
    emoji = Emoji::EYES
    users = event.message.reacted_with(emoji)

    users.each do |user|
      event.message.delete_reaction(user.id, emoji) unless user.current_bot?
    end

    char = Character.find(carousel.char_id)
    embed = character_embed(
      char: char,
      img: CharImage.where(char_id: char.id).find_by(keyword: 'Default'),
      user: event.server.member(char.user_id),
      color: CharacterController.type_color(char),
      section: :all
    )
    event.message.edit("", embed)
  when [:carousel, :key]
    emoji = Emoji::KEY
    users = event.message.reacted_with(emoji)

    users.each do |user|
      event.message.delete_reaction(user.id, emoji) unless user.current_bot?
    end

    char = Character.find(carousel.char_id)
    embed = character_embed(
      char: char,
      img: CharImage.where(char_id: char.id).find_by(keyword: 'Default'),
      user: event.server.member(char.user_id),
      color: CharacterController.type_color(char),
      section: :default
    )
    event.message.edit("", embed)
  when [:carousel, :back]
    event.message.delete_all_reactions

    char = Character.find(carousel.char_id)
    embed = character_embed(
      char: char,
      img: CharImage.where(char_id: char.id).find_by(keyword: 'Default'),
      user: event.server.member(char.user_id),
      color: CharacterController.type_color(char),
      section: :default
    )
    event.message.edit("", embed)
    section_react(event.message)
  when [:carousel, :left], [:carousel, :right]
    emoji = vote == :left ? Emoji::LEFT : Emoji::RIGHT
    users = event.message.reacted_with(emoji)

    users.each do |user|
      event.message.delete_reaction(user.id, emoji) unless user.current_bot?
    end

    char = Character.find(carousel.char_id)
    img = ImageController.img_scroll(
      char_id: char.id,
      nsfw: event.channel.nsfw?,
      img: carousel.image_id,
      dir: vote
    )

    carousel.update(id: carousel.id, image_id: img.id)

    embed = character_embed(
      char: char,
      img: img,
      user: event.server.member(char.user_id),
      color: CharacterController.type_color(char),
      section: :image
    )
    event.message.edit("", embed)

  when [:carousel, :number]
    char_index = nil
    Emoji::NUMBERS.each.with_index do |emoji, i|
      char_index = i if reactions[emoji]&.count.to_i > 1
    end

    if char_index
      event.message.delete_all_reactions

      char = Character.find(carousel.options[char_index])
      carousel.update(id: carousel.id, char_id: char.id)

      embed = character_embed(
        char: char,
        img: CharImage.where(char_id: char.id).find_by(keyword: 'Default'),
        user: event.server.member(char.user_id),
        color: CharacterController.type_color(char),
        section: :default
      )
      event.message.edit("", embed)
      section_react(event.message)
    end
  when [:carousel, :cross]
    event.message.delete
    carousel.delete
  end
end

# This will trigger when any reaction is removed in discord
bot.reaction_remove do |event|
end

# This will trigger when a member is updated
bot.member_update do |event|
end

# This will trigger when anyone joins the server
bot.member_join do |event|
end

# This will trigger when anyone leaves the server
bot.member_leave do |event|
end

# This will trigger when anyone is banned from the server
bot.user_ban do |event|
end

# This will trigger when anyone is un-banned from the server
bot.user_unban do |event|
end

bot.run
