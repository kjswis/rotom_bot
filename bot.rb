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

hello = Command.new(:hello, "Says hello!\nGreat for testing if the bot is responsive") do |event|
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

opts = { "" => "displays a list of all commands", "command" => "displays info and usage for specified command" }
help = Command.new(:help, "Displays help information for the commands", opts) do |event, command|
  short = /pkmn-(\w+)/.match(command) if command
  cmd = short ? short[1] : command if command
  cmd = commands.detect { |c| c.name == cmd.to_sym } if cmd

  if command && cmd
    command_embed(cmd)
  elsif !command
    all_commands_embed(commands)
  else
    command_error_embed("Command not found!", help)
  end
end

opts = { "type" => "" }
matchup = Command.new(:matchup, "Displays a chart of effectiveness for the given type", opts) do |event, type|
  channel = event.channel.id
  file = "images/Type #{type.capitalize}.png"

  if File.exists?(file)
    bot.send_file(channel, File.open(file, 'r'))
  else
    bot.respond("I do not know this pokemon type! Please try again!")
  end
end

opts = { "" => "starts a new app", "name" => "edits an existing app", "name | (in)active" => "sets app to active or inactive" }
app = Command.new(:app, "Everything to do with character applications", opts) do |event, name, status|
  user = event.author
  user_name = user.nickname || user.name
  color = user.color ? user.color.combined : Color::DEFAULT

  character = Character.where(user_id: user.id).find_by(name: name) if name
  active = status.match(/(in)?active/i) if status

  if name && !character
    app_not_found_embed(user_name, name)

  elsif status && active && character
    character.update!(active: active[0].capitalize)
    character.reload

    success_embed("Successfully updated #{name} to be #{active[0].downcase}")
  elsif name && character && !status
    edit_url = Url::CHARACTER + character.edit_url
    embed = edit_app_dm(name, edit_url, color)

    bot.send_message(user.dm.id, "", false, embed)
    edit_app_embed(user_name, name, color)
  elsif !name && !status
    embed = new_app_dm(user_name, color, user.id)

    message = bot.send_message(user.dm.id, "", false, embed)
    message.react(Emoji::PHONE)

    new_app_embed(user_name, color)
  else
    command_error_embed("There was an error processing your application!", app)
  end
end

opts = { "question | option1, option2, etc" => "Creates a poll for the specified question with the given options"}
poll = Command.new(:poll, "Creates a dynamic poll in any channel", opts) do |event, question, options|
  options_array = options.split(/\s?,\s?/) if options
  new_poll_embed(event, question, options_array) if options

  command_error_embed("There was an error creating your poll!", poll) unless question && options
end

opts = { "participants" => "May accept Everyone, Here, or a comma seperated list of names"}
raffle = Command.new(:raffle, "Creates a raffle and picks a winner", opts) do |event, participant|
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
      new_generic_embed(event, "Raffle Results!", "Winner: " + winner_name)
    else
      command_error_embed("There was an error creating your raffle!", raffle)
    end
end

opts = { "name | key, words | (n)sfw | url" => "" }
image = Command.new(:image, "Edit your character's images", opts) do |event, name, keyword, tag, url|
  character = Character.where(user_id: event.author.id).find_by!(name: name) if name
  category = /(n)?sfw/i.match(tag) if tag

  if character && category
    image = "_New Character Image_:\n\n>>> **Character**: #{character.name}\n**Species**: #{character.species}"
    image += "\n\n**Character ID**: #{character.id}\n**Keyword**: #{keyword}\n**Category**: #{tag}\n\n**URL**: #{url}"
    approval = bot.send_message(Channel::APPROVAL, image, false, nil)

    approval.react(Emoji::Y)
    approval.react(Emoji::N)
  end

  if approval
    success_embed("Your image has been submitted for approval!")
  else
    error_embed("Something went wrong!")
  end
rescue ActiveRecord::RecordNotFound
  error_embed("Could not find your character name #{name}")
end

# ---

commands = [
  hello,
  matchup,
  app,
  help,
  poll,
  raffle
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

  event.send_embed("", error_embed("Command not found!")) if command && !cmd && event.server

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

  maj = event.server.roles.find{ |r| r.id == ADMINS }.members.count / 2 if event.server
  maj = 1

  form =
    case
    when event.message.author.id == Bot::CHARACTER
      :character_application
    when event.message.from_bot? && content.match(Regex::CHAR_APP)
      :character_rejection
    when event.message.from_bot? && event.server.nil?
      :user_key
    when event.message.from_bot? && content.match(/\_New\sCharacter\sImage\_:/)
      :image_application
    end

  vote =
    case
    when reactions[Emoji::Y].present? && reactions[Emoji::Y].count > maj
      :yes
    when reactions[Emoji::N].present? && reactions[Emoji::N].count > maj
      :no
    when reactions[Emoji::CHECK].present? && reactions[Emoji::CHECK].count > 1
      :check
    when reactions[Emoji::CROSS].present? && reactions[Emoji::CROSS].count > 1
      :cross
    when reactions[Emoji::CRAYON].present? && reactions[Emoji::CRAYON].count > 1
      :crayon
    when reactions[Emoji::PHONE].present? && reactions[Emoji::PHONE].count > 1
      :phone
    end

  case [form, vote]
  when [:character_application, :yes]
    params = content.split("\n")
    uid = Regex::UID.match(content)
    member = event.server.member(uid[1])

    character = CharacterController.edit_character(params)
    image_url = ImageController.default_image(content, character.id)

    embed = character_embed(character, image_url, member) if character
    bot.send_message(
      Channel::CHARACTER,
      "Good news, <@#{member.id}>! Your character was approved",
      false,
      embed
    ) if embed

    event.message.delete if embed
    event.respond("", admin_error_embed("Something went wrong when saving application")) unless embed

  when [:character_application, :no]
    reject_app(event, reject_char_embed(content))

  when [:character_rejection, :check]
    member = event.server.member(Regex::UID.match(content)[1])
    embed = message_user_embed(event)

    event.message.delete
    bot.send_temporary_message(event.channel.id, "", 5, false, embed)
    bot.send_message(member.dm.id, "", false, embed)
  when [:character_rejection, :cross]
    event.message.delete

  when [:character_rejection, :crayon]
    event.message.delete
    bot.send_temporary_message(event.channel.id, "", 35, false, self_edit_embed(content))

  when [:user_key, :phone]
    event.message.delete_own_reaction(Emoji::PHONE)
    user = event.message.reacted_with(Emoji::PHONE).first

    bot.send_message(user.dm.id, user.id, false, nil)
  when [:image_application, :yes]
    params = content.split("\n")
    image = ImageController.edit_image(params)

    char = Character.find(image.char_id)
    user = event.server.member(char.user_id)
    embed = char_image_embed(char.name, image, user)

    event.message.delete if embed
    channel = image.category.upcase == 'SFW' ? Channel::CHARACTER : Channel::CHARACTER_NSFW
    bot.send_message(channel, "Image Approved!", false, embed)
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
