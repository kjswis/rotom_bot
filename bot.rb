require 'bundler'
require 'erb'
require 'yaml'
require 'json'
require 'terminal-table'
require 'rmagick'
require 'down'

BOT_ENV = ENV.fetch('BOT_ENV') { 'development' }
Bundler.require(:default, BOT_ENV)

require 'active_record'

# Constants: such as roles and colors and regexes

DISCORD = "#36393f"
ERROR = "#a41e1f"

UID = /<@\!?([0-9]+)>/
URL = /https?:\/\/[\S]+/

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
Dir['./lib/*.rb'].each { |f| require f }

token = ENV['DISCORD_BOT_TOKEN']
bot = Discordrb::Bot.new(token: token)

# Methods

def stat_image(user, member, stats=nil)
  size_width = 570;
  size_height = 376;
  stats_frame =  "images/LevelUp.png"
  level_up = "images/LevelUpFont.png"
  user_url_img = "images/Image_Builder/user_url_img.png"
  output_file =  "images/Image_Builder/LevelUp"

  begin
    Down.download(member.avatar_url, destination: user_url_img)
  rescue Down::NotFound
    user_url_img = "images/Image_Builder/unknown_img.png"
  end

  #Gif Destroyer
  i = Magick::ImageList.new(user_url_img)
  i[0].write(user_url_img) if i.count > 1

  if stats
    merge_image(
      [stats_frame, level_up, user_url_img],
      output_file,
      size_width,
      size_height,
      [nil, nil, 19],
      [nil, nil, 92],
      [size_width, size_width, 165],
      [size_height, size_height, 165]
    )
  else
    merge_image(
      [stats_frame, user_url_img],
      output_file,
      size_width,
      size_height,
      [nil, 19],
      [nil, 92],
      [size_width, 165],
      [size_height, 165]
    )
  end

  last_level = user.level == 1 ? 0 : ((user.level + 4) **3) / 10.0
  this_level = user.next_level - last_level
  ratio = 1 - ((user.next_level - user.boosted_xp).to_f / this_level)

  user_name = member.nickname || member.name
  short_name = user_name.length > 15 ? "#{user_name[0..14]}..." : user_name
  rank = User.order(unboosted_xp: :desc)
  user_rank = rank.index{ |r| r.id == user.id } + 1

  gc = Draw.new

  gc.font('OpenSans-SemiBold.ttf')

  gc.stroke('#39c4ff').fill('#39c4ff')
  gc.rectangle(42, 48, 42 + (95 * ratio), 48 + 3)

  gc.stroke('none').fill('black')
  gc.pointsize('15')
  gc.text(15,25, short_name)
  gc.text(40, 45, "Lv.#{user.level}")
  gc.text(15, 290, "Rank: #{user_rank}")
  gc.text(40, 65, "Exp: #{user.boosted_xp}")

  gc.stroke('white').fill('white')
  gc.pointsize('30')
  gc.text(40,330, user_name)
  gc.text(40,360, "reached level #{user.level}!") if stats
  gc.text(40,360, "is level #{user.level}!") if !stats

  if stats
    gc.stroke('none').fill('black')
    gc.pointsize('18')
    gc.text(450, 97, stats['hp'].to_s)
    gc.text(450, 127, stats['attack'].to_s)
    gc.text(450, 159, stats['defense'].to_s)
    gc.text(450, 191, stats['sp_attack'].to_s)
    gc.text(450, 222, stats['sp_defense'].to_s)
    gc.text(450, 255, stats['speed'].to_s)

    gc.stroke('none').fill('maroon')
    gc.text(505, 97, "+ #{stats['hp'] - user.hp}")
    gc.text(505, 127, "+ #{stats['attack']- user.attack}")
    gc.text(505, 159, "+ #{stats['defense'] - user.defense}")
    gc.text(505, 191, "+ #{stats['sp_attack'] - user.sp_attack}")
    gc.text(505, 222, "+ #{stats['sp_defense']- user.sp_defense}")
    gc.text(505, 255, "+ #{stats['speed'] - user.speed}")
  else
    gc.stroke('none').fill('black')
    gc.pointsize('18')
    gc.text(450, 97, user.hp.to_s)
    gc.text(450, 127, user.attack.to_s)
    gc.text(450, 159, user.defense.to_s)
    gc.text(450, 191, user.sp_attack.to_s)
    gc.text(450, 222, user.sp_defense.to_s)
    gc.text(450, 255, user.speed.to_s)
  end

  u = Magick::ImageList.new("#{output_file}.png")
  gc.draw(u[0])

  u.write("#{output_file}.png")
  "#{output_file}.png"
end

#--

# Commands: structure basic bot commands here
commands = []
pm_commands = []

hello = Command.new(:hello, "Says hello!") do |event|
  user = event.author.nickname || event.author.name
  img = ImageUrl.find_by(name: 'happy')

  greetings = [
    "Hi there, #{user}",
    "Greetings #{user}, you lovable bum",
    "Alola, #{user}",
    "Hello, #{user}! The Guildmasters have been waiting",
    "#{user} would like to battle!"
  ]

  Embed.new(
    description: greetings.sample,
    color: event.author&.color&.combined,
    thumbnail: {
      url: img.url
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

opts = {
  "primary" => "Single Display",
  "primary | secondary" => "Double Display"
}
desc = "Displays a chart of effectiveness for the given type"
matchup = Command.new(:matchup, desc, opts) do |event, primary, secondary|
  channel = event.channel.id
  image_out = 'images/Type Double.png'

  file_p = "images/Type #{primary.capitalize}.png" if primary
  file_s = "images/Type #{secondary.capitalize}.png" if secondary

  case
  when !file_p
    command_error_embed("There was an error processing your request!", matchup)
  when !file_s && File.exists?(file_p)
    bot.send_file(channel, File.open(file_p, 'r'))
  when File.exists?(file_p) && File.exists?(file_s)
    append_image(file_p, file_s, image_out)
    bot.send_file(channel, File.open(image_out, 'r'))
  else
    error_embed("Type(s) not found!")
  end
end

opts = {
  "@user" => "List all user stats",
}
desc = "Shows ones stats, level, rank, and experience"
stats = Command.new(:stats, desc, opts) do |event, name, all|

  case name
  when UID
    user_id = UID.match(name)
    user = event.server.member(user_id[1])
  when /ghost/i
    users = User.all
    ghosts = []

    users.each do |u|
      ghosts.push("<@#{u.id}>") if event.server.member(u.id).nil?
    end

    embed = Embed.new(
      title: "Ghost Members",
      description: ghosts.join(", ")
    )

    event.send_embed("", embed)
  end

  usr = User.find_by!(id: user&.id)

  case all
  when /all/i
    show_stats(usr, user)
  when /reroll/i
    usr.make_stats
    usr.reload
    show_stats(usr, user)
  else
    output_file = stat_image(usr, user)
    bot.send_file(event.channel.id, File.open(output_file, 'r'))
  end
rescue ActiveRecord::RecordNotFound => e
  error_embed(e.message)
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
  color = user.color.combined if event.server && user.color
  chars = []

  if user.roles.map(&:name).include?('Guild Masters')
    flag = case status
           when /landmark/i then :lm
           when /legend/i then :legend
           when /guild/i then :guild
           end
  end

  character =
    if user.roles.map(&:name).include?('Guild Masters')
      chars = Character.where(name: name)
      chars.first if chars.length == 1
    else
      Character.where(user_id: user.id).find_by(name: name) if name
    end
  active = case status
           when /inactive/i, /archive/i
             false
           when /active/i
             true
           end

  case
  when flag
    case flag
    when :lm
      lm = Landmark.find_by(name: name)
      edit_url = 'https://docs.google.com/forms/d/e/1FAIpQLSc1aFBTJxGbvauUOGF1WGEvik5SJ_3SFkyIfbR2h8eK8Fxe7Q/viewform'
      edit_url+= lm.edit_url

      embed = edit_app_dm(name, edit_url)
    when :legend, :guild
      character.update(special: status.downcase)
      success_embed("Updated #{name} to have #{status} flag")
    end
  when !chars.empty? && !character
    chars.each do |char|
      edit_url = Url::CHARACTER + char.edit_url
      embed = edit_app_dm(name, edit_url, color)

      bot.send_message(
        user.dm.id,
        "<@#{char.user_id}>'s character:",
        false,
        embed
      )
    end
  when name && !character
    app_not_found_embed(user_name, name)

  when status && character
    if active
      uid = character.user_id
      user_allowed = (User.find_by(id: uid).level / 10) + 1
      user_allowed = user_allowed + 1 if user.roles.map(&:name).include?('Nitro Booster')
      active_chars = Character.where(user_id: uid, active: 'Active')

      allowed = active_chars.count < user_allowed && character.active == 'Archived'
    else
      allowed = true
    end

    if allowed && active
      # create re-approval character embed
      img = CharImage.where(char_id: character.id).find_by(keyword: 'Default')
      color = CharacterController.type_color(character)

      app = character_embed(
        char: character,
        img: img,
        section: :default,
        user: user,
        color: color,
        event: event
      )

      app.author = { name: "Reactivation Application [#{character.id}]" }
      msg = bot.send_message(ENV['APP_CH'], "", false, app)
      msg.react(Emoji::Y)
      msg.react(Emoji::N)
      msg.react(Emoji::CRAYON)
      msg.react(Emoji::CROSS)

      success_embed("Successfully requested #{name} to be Reactivated!")
    elsif allowed && !active
      character.update!(active: 'Archived')
      character.reload

      embed = success_embed("Successfully archived #{name}")
      bot.send_message(ENV['APP_CH'], "", false, embed)
      embed
    else
      error_embed(
        "You're not allowed to do that!",
        "You either have too many active characters, the character is already active, or it is an NPC"
      )
    end
  when name && character && !status
    edit_url = Url::CHARACTER + character.edit_url
    embed = edit_app_dm(name, edit_url, color)

    bot.send_message(user.dm.id, "", false, embed)
    edit_app_embed(user_name, name, color) if event.server
  when !name && !status
    embed = new_app_dm(user_name, user.id, color)

    message = bot.send_message(user.dm.id, "", false, embed)
    message.react(Emoji::PHONE)

    new_app_embed(user_name, color) if event.server
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
image = Command.new(:image, desc, opts) do |event, name, keyword, tag, url, id|
  user = event.author

  char =
    if id
      Character.where(user_id: id).find_by!(name: name) if name
    else
      Character.where(user_id: user.id).find_by!(name: name) if name
    end
  color = CharacterController.type_color(char) if char
  img = CharImage.where(char_id: char.id).find_by(keyword: keyword) if keyword

  case
  when /^Default$/i.match(keyword)
    error_embed(
      "Cannot update Default here!",
      "Use `pkmn-app character` to edit your default image in your form"
    )
  when char && keyword && url && tag && tag.match(/(n)?sfw/i)
    img_app = CharImage.to_form(
      char: char,
      keyword: keyword,
      category: tag,
      url: url,
      user_id: user.id
    )

    approval = bot.send_message(ENV['APP_CH'].to_i, "", false, img_app)
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
  sections = [:all, :default, :bio, :type, :status, :rumors, :image, :bags]

  case name
  when UID
    user_id = UID.match(name)
  when String
    chars = Character.where(name: name)
    char = chars.first if chars.length == 1

    if char
      img = CharImage.where(char_id: char.id).find_by(keyword: 'Default')
      user = case char.user_id
             when /public/i, /server/i
               char.user_id
             else
               event.server.member(char.user_id)
             end
      color = CharacterController.type_color(char)
    end
  end

  case
  when !name
    chars = Character.where(active: 'Active').order(:name)
    types = Type.all

    embed = char_list_embed(chars, 'active', types)
    msg = event.send_embed("", embed)
    Carousel.create(message_id: msg.id)

    msg.react(Emoji::ONE)
    msg.react(Emoji::TWO)
    msg.react(Emoji::THREE)
    msg.react(Emoji::FOUR)
    msg.react(Emoji::CROSS)
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
  when name && chars.empty?
    error_embed(
      "Character not found!",
      "Could not find a character named #{name}"
    )
  when name && chars && !char
    embed = dup_char_embed(chars, name)
    chars_id = chars.map(&:id)

    msg = event.send_embed("", embed)
    Carousel.create(message_id: msg.id, options: chars_id)

    option_react(msg, chars_id)
  when name && char && !section
    if char.rating == 'NSFW' && !event.channel.nsfw?
      embed = nsfw_char_embed(char: char, user: user, color: color, event: event)
    else
      embed = character_embed(
        char: char,
        img: img,
        section: :default,
        user: user,
        color: color,
        event: event
      )
    end
    msg = event.send_embed("", embed)
    Carousel.create(message_id: msg.id, char_id: char.id)

    section_react(msg)
  when char && section && keyword
    img = CharImage.where(char_id: char.id).find_by!(keyword: keyword)

    if img.category == 'NSFW' && !event.channel.nsfw?

      embed = error_embed(
        "Wrong Channel!",
        "The requested image is NSFW"
      )
    elsif !/image/i.match(section)
      embed = command_error_embed(
        "Invalid Arguments",
        member
      )
    else
      embed = character_embed(
        char: char,
        img: img,
        section: :image,
        user: user,
        color: color,
        event: event
      )

      msg = event.send_embed("", embed)
      Carousel.create(message_id: msg.id, char_id: char.id, image_id: img.id)

      arrow_react(msg)
    end
  when name && char && section
    sect = section.downcase.to_sym
    nsfw = event.channel.nsfw?

    img = ImageController.img_scroll(
      char_id: char.id,
      nsfw: nsfw
    )if section == :image

    if char.rating == 'NSFW' && !event.channel.nsfw?
      embed = nsfw_char_embed(char: char, user: user, color: color, event: event)

      msg = event.send_embed("", embed)
      Carousel.create(
        message_id: msg.id,
        char_id: char.id,
      )

      section_react(msg)
    elsif sections.detect{ |s| s == sect }
      embed = character_embed(
        char: char,
        img: img,
        section: sect,
        user: user,
        color: color,
        event: event
      )

      msg = event.send_embed("", embed)
      Carousel.create(
        message_id: msg.id,
        char_id: char.id,
        image_id: img ? img.id : nil
      )

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

desc = "Learn about Items"
opts = { "" => "list all items", "item_name" => "show known info for the item" }
item = Command.new(:item, desc, opts) do |event, name|
  i = name ? Item.find_by!(name: name.capitalize) : Item.all

  case
  when name && i
    item_embed(i)
  when !name && i
    item_list_embed(i)
  #else
    #command_error_embed("Error proccessing your request!", item)
  end
#rescue ActiveRecord::RecordNotFound
  #error_embed("Item Not Found!")
end

desc = "Add and remove items from characters' inventories"
opts = { "item | (-/+) amount | character" => "negative numbers remove items" }
inv = Command.new(:inv, desc, opts) do |event, item, amount, name|
  char = Character.find_by!(name: name) if name
  itm = Item.find_by!(name: item) if item
  amt = amount.to_i

  if char && itm && amt && event.user.roles.map(&:name).include?('Guild Masters')
    i = Inventory.update_inv(itm, amt, char)
    user = event.server.member(char.user_id.to_i)
    color = CharacterController.type_color(char)

    case i
    when Inventory, true
      character_embed(char: char, user: user, color: color, section: :bags, event: event)
    when Embed
      i
    else
      error_embed("Something went wrong!", "Could not update inventory")
    end
  elsif !event.user.roles.map(&:name).include?('Guild Masters')
    error_embed("You don't have permission to do that!")
  else
    command_error_embed("Could not proccess your request", inv)
  end
rescue ActiveRecord::RecordNotFound => e
  error_embed(e.message)
end

desc = "Update or edit statuses"
opts = { "name | effect" => "effect displays on user when afflicted" }
status = Command.new(:status, desc, opts) do |event, name, effect, flag|
  admin = event.user.roles.map(&:name).include?('Guild Masters')

  if name && effect && admin
    s = StatusController.edit_status(name, effect, flag)

    case s
    when Status
      status_details(s)
    when Embed
      s
    end
  elsif name && !effect
    status_details(Status.find_by!(name: name))
  elsif !name && !effect
    status_list
  elsif !admin
    error_embed("You do not have permission to do that!")
  else
    command_error_embed("Could not create status!", status)
  end
rescue ActiveRecord::RecordNotFound => e
  error_embed(e.message)
end

opts = { "character | ailment | %afflicted" => "afflictions apply in percentages" }
afflict = Command.new(:afflict, desc, opts) do |event, name, status, amount|
  char = Character.find_by!(name: name) if name
  st = Status.find_by!(name: status) if status

  user = char.user_id.match(/public/i) ?
    'Public' : event.server.member(char.user_id)

  if st && char
    user = char.user_id.match(/public/i) ?
      'Public' : event.server.member(char.user_id)
    color = CharacterController.type_color(char)

    s = StatusController.edit_char_status(char, st, amount)

    case s
    when CharStatus
      character_embed(char: char, user: user, color: color, section: :status, event: event)
    when Embed
      s
    end
  else
    command_error_embed("Error afflicting #{char.name}", afflict)
  end
rescue ActiveRecord::RecordNotFound => e
  error_embed(e.message)
end

opts = {
  "character | all" => "completely cures all ailments",
  "character | ailment" => "completely cures the ailment",
  "character | ailment | %cured" => "cures a percentage of ailment"
}
cure = Command.new(:cure, desc, opts) do |event, name, status, amount|
  char = Character.find_by!(name: name) if name
  st = Status.find_by!(name: status) if status && !status.match(/all/i)

  case
  when char && st && amount
    user = char.user_id.match(/public/i) ?
      'Public' : event.server.member(char.user_id)
    color = CharacterController.type_color(char)

    s = StatusController.edit_char_status(st, "-#{amount}", char)

    case s
    when CharStatus
      character_embed(char: char, user: user, color: color, section: :status, event: event)
    when Embed
      s
    end
  when char && st && !amount
    CharStatus.where(char_id: char.id).find_by!(status_id: st.id).delete
    success_embed("Removed #{status} from #{name}")
  when char && status && status.match(/all/i)
    csts = CharStatus.where(char_id: char.id)
    csts.each do |cst|
      cst.delete
    end

    success_embed("Removed all ailments from #{name}")
  else
  end

rescue ActiveRecord::RecordNotFound => e
  error_embed(e.message)
end

desc = "Everything to do with rescue teams"
opts = {
  "" => "list of teams",
  "team_name" => "display team info",
  "team_name | (leave/apply) | character" => "leave or apply for team",
  "team_name | create | description" => "apply to create a new team",
  "team_name | update | description" => "must be used in team chat channel"
}
team = Command.new(:team, desc, opts) do |event, team_name, action, desc|
  unless action&.match(/create/i) || action&.match(/update/i)
    t = Team.find_by!(name: team_name) if team_name
    user = User.find_by(id: event.author.id)

    char = if event.author.roles.map(&:name).include?('Guild Masters')
             Character.find_by!(name: desc) if desc
           else
             c = Character.where(user_id: event.author.id).find_by!(name: desc) if desc
             ct = CharTeam.where(char_id: c.id).find_by(active: true) if c
             action = "second_team" if ct && action.match(/apply/i)
             c
           end
  end

  case action
  when /leave/i
    ct = CharTeam.where(team_id: t.id).find_by(char_id: char.id)

    if ct
      ct.update(active: false)
      user = event.server.member(char.user_id.to_i)

      sql = "SELECT name " +
        "FROM char_teams JOIN characters " +
        "ON char_teams.char_id = characters.id " +
        "WHERE characters.user_id = ? " +
        "AND char_teams.team_id = ? " +
        "and char_teams.active = true;"

      sql =
        ActiveRecord::Base.send(:sanitize_sql_array, [sql, user.id.to_s, t.id])
      user_characters_team = ActiveRecord::Base.connection.exec_query(sql)
      user.remove_role(t.role.to_i) if user_characters_team.count == 0

      bot.send_message(
        t.channel.to_i,
        "#{char.name} has left the team",
        false,
        nil
      )
    end
  when /apply/i
    members = CharTeam.where(team_id: t.id, active: true)
    if members.count >= 6
      error_embed("#{t.name} is full!")
    elsif user.level < 5
      error_embed("You are not high enough level!")
    else
      embed = team_app_embed(t, char, event.server.member(char.user_id))
      msg = bot.send_message(t.channel.to_i, "", false, embed)

      msg.react(Emoji::Y)
      msg.react(Emoji::N)
      success_embed("Your request has been posted to #{t.name}!")
    end
  when /create/i
    team_name = team_name || ""
    desc = desc || ""

    embed = new_team_embed(event.message.author, team_name, desc)
    msg = bot.send_message(ENV['APP_CH'], "", false, embed)

    msg.react(Emoji::Y)
    msg.react(Emoji::N)
    success_embed("Your Team Application has been submitted!")
  when /update/i
    team_name = team_name || ""
    desc = desc || ""

    t = Team.find_by(channel: event.message.channel.id)

    if t
      t.update(name: team_name, description: desc)
      t.reload

      team_embed(t)
    else
      error_embed("Must be used in team chat")
    end
  when nil
    t ? team_embed(t) : teams_embed()
  when /second_team/i
    error_embed("#{char.name} is already in a team!")
  else
    command_error_embed("Could not process team request!", team)
  end
rescue ActiveRecord::RecordNotFound => e
  error_embed(e.message)
end

desc = 'roll or create dice'
opts = {
  '' => 'shows die options',
  'xdy' => 'rolls x number of y sided die',
  'a,b,c,d' => 'rolls the between the provided options',
  'die_name' => 'rolls the given die',
  'die_name | a,b,c,d' => 'creates the die'
}
roll = Command.new(:roll, desc, opts) do |event, die, array|
  usr = event.message.author
  usr_name = usr.nickname || usr.name
  color = usr.color&.combined if event.server

  case die
  when /([0-9]*?)d([0-9]+)/i
    result = DiceController.roll(die)
  when /,/
    result = DiceController.roll(die.split(/\s?,\s?/))
  when nil
    result = dice_embed
  else
    a = usr.roles.map(&:name).include?('Guild Master')
    d = DieArray.find_by(name: die.capitalize)

    if !d && array && a
      result =
        DieArray.create(name: die.capitalize, sides: array.split(/\s?,\s?/))
    elsif d && array && a
      d.update(sides: array.split(/\s?,\s?/))
      d.reload
      result = d
    elsif d && !array
      result = DiceController.roll(d.sides)
    else
      result = error_embed('Die not found!')
    end
  end

  case result
  when String, Integer
    Embed.new(description: "#{usr_name} rolled #{result}!", color: color)
  when DieArray
    success_embed("Created Die, #{die}, with sides: #{result.sides}")
  when Embed
    result
  end
end

opts = {
  "" => "List all landmarks",
  "name " => "Display the given landmark",
}
desc = "Display info about the guild members"
landmark = Command.new(:landmark, desc, opts) do |event, name, section, keyword|
  lm = Landmark.find_by!(name: name) if name

  usr = case lm&.user_id
        when /server/i
          lm&.user_id
        else
          event.server.member(lm&.user_id)
        end

  if lm && !section && !keyword
    embed = landmark_embed(lm: lm, user: usr, event: event)
    msg = event.send_embed("", embed)
    Carousel.create(message_id: msg.id, landmark_id: lm.id)

    landmark_react(msg)
  elsif lm && section && !keyword
    case section
    when /history/i
      embed = landmark_embed(lm: lm, user: usr, section: :history, event: event)
    when /warnings?/i
      embed = landmark_embed(lm: lm, user: usr, section: :warning, event: event)
    when /map/i
      embed = landmark_embed(lm: lm, user: usr, section: :map, event: event)
    when /layout/i
      embed = landmark_embed(lm: lm, user: usr, section: :layout, event: event)
    when /npcs?/i
      embed = landmark_embed(lm: lm, user: usr, section: :npcs, event: event)
    end

    msg = event.send_embed("", embed)
    Carousel.create(message_id: msg.id, landmark_id: lm.id)

    landmark_react(msg)
  elsif !name && !section && !keyword
    landmark_list
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
  member,
  item,
  inv,
  status,
  afflict,
  cure,
  team,
  stats,
  roll,
  landmark
]

#locked_commands = [inv]

# This will trigger on every message sent in discord
bot.message do |event|
  content = event.message.content
  author = event.author.id
  clear_channels = [473582694802915328, 644771348073152522, 705530816410943539]

  command = /^pkmn-(\w+)/.match(content)
  cmd = commands.detect { |c| c.name == command[1].to_sym } if command

  if cmd
    reply = cmd.call(content, event)

    case reply
    when Embed
      event.send_embed("", reply)
    when String
      event.respond(reply)
    end
  #elsif command && !cmd && event.server
    #event.send_embed(
      #"",
      #error_embed("Command not found!")
    #)
  elsif author == ENV['WEBHOOK'].to_i
    app = event.message.embeds.first
    if app.author.name == 'Character Application'
      Character.check_user(event)
    else
      approval_react(event)
    end
  elsif clear_channels.include? event.message.channel.id
    if content.match(/clear chat/i)
      msgs = event.message.channel.history(50)
      msgs = msgs.reject { |msg| msg.author.webhook? || msg.id == 651836628486062081 }

      event.message.channel.delete_messages(msgs)
    end

  elsif event.message.channel.id == 454082477192118275 || event.message.channel.id == 613365750383640584 || event.message.channel.id == 473582694802915328 || event.message.channel.id == 598217431202398259
  elsif !event.author.bot_account? && !event.author.webhook? && event.server
    usr = User.find_by(id: author.to_s)
    msg = URL.match(content) ? content.gsub(URL, "x" * 150) : content
    file = event.message.attachments.map(&:filename).count
    msg = file > 0 ? msg + ("x" * 40) : msg

    img = usr.update_xp(msg, event.author)
    bot.send_file(event.message.channel, File.open(img, 'r')) if img
  end
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
  reactions = event.message.reactions
  app = event.message.embeds.first
  carousel = Carousel.find_by(message_id: event.message.id)
  team_chat = Team.find_by(channel: event.message.channel.id)
  maj = 100
  star = false

  if stars = event.message.reacted_with(Emoji::STAR)
    stars.each do |s|
      u = event.server.member(s.id)
      star = true if u.roles.map(&:name).include? "Guild Masters"
    end
  end

  form =
    case app&.author&.name
    when 'New App' then :new_app
    when 'Character Application'
      m = event.server.roles.find{ |r| r.id == ENV['ADMINS'].to_i }.members
      maj = m.count > 2 ? m.count/2.0 : 2
      :character_application
    when 'Character Rejection' then :character_rejection
    when 'Image Application'
      m = event.server.roles.find{ |r| r.id == ENV['ADMINS'].to_i }.members
      maj = m.count > 2 ? m.count/2.0 : 2
      :image_application
    when 'Image Rejection' then :image_rejection
    when 'Item Application'
      m = event.server.roles.find{ |r| r.id == ENV['ADMINS'].to_i }.members
      maj = m.count > 2 ? m.count/2.0 : 2
      :item_application
    when 'Item Rejection' then :item_rejection
    when 'Team Application'
      m = event.server.roles.find{ |r| r.id == ENV['ADMINS'].to_i }.members
      maj = m.count > 2 ? m.count/2.0 : 2
      :team_application
    when 'Team Join Request'
      team_id = Team.find_by(channel: event.message.channel.id.to_s).role.to_i
      m = event.server.roles.find{ |r| r.id == team_id }.members
      maj = m.count > 2 ? m.count/2.0 : 2
      :team_request
    when 'Landmark Application'
      m = event.server.roles.find{ |r| r.id == ENV['ADMINS'].to_i }.members
      maj = m.count > 2 ? m.count/2.0 : 2
      :landmark_application
    when /Reactivation\sApplication/
      m = event.server.roles.find{ |r| r.id == ENV['ADMINS'].to_i }.members
      maj = m.count > 2 ? m.count/2.0 : 2
      :reactivation
    else
      if event.server == nil
        :new_app
      elsif carousel&.char_id || carousel&.options
        :member
      elsif carousel&.landmark_id
        :landmark
      elsif carousel&.message_id
        :member
      elsif team_chat
        :team_chat
      end
    end

  vote =
    case
    when reactions[Emoji::Y]&.count.to_i > maj && star then :yes
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
    #when reactions[Emoji::FAMILY]&.count.to_i > 1 then :family
    when reactions[Emoji::EYES]&.count.to_i > 1 then :eyes
    when reactions[Emoji::KEY]&.count.to_i > 1 then :key
    when reactions[Emoji::PHONE]&.count.to_i > 1 then :phone
    when reactions[Emoji::LEFT]&.count.to_i > 1 then :left
    when reactions[Emoji::RIGHT]&.count.to_i > 1 then :right
    when reactions[Emoji::UNDO]&.count.to_i > 1 then :back
    when reactions[Emoji::BOOKS]&.count.to_i > 1 then :books
    when reactions[Emoji::SKULL]&.count.to_i > 1 then :skull
    when reactions[Emoji::MAP]&.count.to_i > 1 then :map
    when reactions[Emoji::HOUSES]&.count.to_i > 1 then :houses
    when reactions[Emoji::PEOPLE]&.count.to_i > 1 then :people
    when reactions[Emoji::BUST]&.count.to_i > 1 then :bust
    when reactions[Emoji::PIN]&.count.to_i > 0 then :pin
    when reactions.any? { |k,v| Emoji::NUMBERS.include? k } then :number
    end

  case [form, vote]
  when [:character_application, :yes]
    uid = UID.match(app.description)
    user =
      app.description.match(/public/i) ? 'Public' : event.server.member(uid[1])
    img_url = case
              when !app.thumbnail&.url.nil? then app.thumbnail.url
              when !app.image&.url.nil? then app.image.url
              end

    char = CharacterController.edit_character(app)
    img = ImageController.default_image(
      img_url,
      char.id,
      char.rating
    )if img_url
    color = CharacterController.type_color(char)
    channel = case char.rating
              when /nsfw/i
                ENV['CHAR_NSFW_CH']
              when /hidden/i
                if user&.current_bot?
                  event.channel.id
                else
                  user.dm&.id
                end
              else
                ENV['CHAR_CH']
              end

    embed = character_embed(
      char: char,
      img: img,
      user: user,
      color: color,
      event: event
    )if char

    if embed
      bot.send_message(
        channel.to_i,
        "Good news, #{uid}! Your character was approved",
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
    embed = reject_app_embed(app, :character)

    event.message.delete
    reject = event.send_embed("", embed)

    Emoji::CHAR_APP.each do |reaction|
      reject.react(reaction)
    end

    reject.react(Emoji::CHECK)
    reject.react(Emoji::CROSS)
    reject.react(Emoji::CRAYON)

  when [:character_application, :cross]
    event.message.delete

  when [:character_application, :crayon]
    event.message.delete
    bot.send_temporary_message(
      event.channel.id,
      "",
      35,
      false,
      self_edit_embed(app, Url::CHARACTER)
    )

  when [:character_rejection, :check]
    user = event.server.member(UID.match(app.description)[1])
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
      self_edit_embed(app, Url::CHARACTER)
    )

  when [:reactivation, :yes]
    ch_id = app.author.name.match(/\[(\d+)\]/)
    char = Character.find(ch_id[1])

    img = CharImage.where(char_id: char.id).find_by(keyword: 'Default')
    color = CharacterController.type_color(char)
    user = case char.user_id
           when /server/i
             char.user_id
           else
             event.server.member(char.user_id.to_i)
           end

    channel = case char.rating
              when /nsfw/i
                ENV['CHAR_NSFW_CH']
              when /hidden/i
                user.dm&.id
              else
                ENV['CHAR_CH']
              end

    char.update(active: 'Active')
    char.reload

    embed = character_embed(
      char: char,
      img: img,
      user: user,
      color: color,
      event: event
    )if char

    if embed
      bot.send_message(
        channel.to_i,
        "Good news, <@#{char.user_id}>! Your character was approved",
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
  when [:reactivation, :no]
    ch_id = app.author.name.match(/\[(\d)+\]/)
    char = Character.find(ch_id[1])

    user = event.server.member(char.user_id)
    embed = char_reactive(Url::CHARACTER, char.edit_url)

    event.message.delete
    bot.send_temporary_message(event.channel.id, "", 5, false, embed)
    bot.send_message(user.dm.id, "", false, embed)

  when [:reactivation, :cross]
    event.message.delete

  when [:reactivation, :crayon]
    ch_id = app.author.name.match(/\[(\d)+\]/)
    char = Character.find(ch_id[1])

    event.message.delete
    bot.send_temporary_message(
      event.channel.id,
      "",
      35,
      false,
      char_reactive(Url::CHARACTER, char.edit_url)
    )

  when [:landmark_application, :yes]
    uid = UID.match(app.description)
    user =
      app.description.match(/server/i) ? 'Server' : event.server.member(uid[1])
    img_url = case
              when !app.thumbnail&.url.nil? then app.thumbnail.url
              when !app.image&.url.nil? then app.image.url
              end

    lm = LandmarkController.edit_landmark(app)

    embed = landmark_embed(lm: lm, user: user, event: event)if lm
    channel = '453277760429883393'
    if embed
      bot.send_message(
        channel.to_i,
        "Good news, #{uid}! Your landmark was approved",
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

  when [:landmark_application, :cross]
    event.message.delete

  when [:landmark_application, :crayon]
    event.message.delete
    bot.send_temporary_message(
      event.channel.id,
      "",
      35,
      false,
      self_edit_embed(app, Url::LANDMARK)
    )

  when [:new_app, :phone]
    event.message.delete_own_reaction(Emoji::PHONE)
    user = event.message.reacted_with(Emoji::PHONE).first

    bot.send_message(user.dm.id, user.id, false, nil)
  when [:image_application, :yes]
    img = ImageController.edit_image(app)

    char = Character.find(img.char_id)
    user = event.server.member(char.user_id)
    color = CharacterController.type_color(char)

    embed = char_image_embed(char, img, user, color)

    event.message.delete if embed
    channel = if img.category == 'SFW'
                ENV['CHAR_CH'].to_i
              else
                ENV['CHAR_NSFW_CH'].to_i
              end
    bot.send_message(channel, "Image Approved!", false, embed)
  when [:image_application, :no]
    embed = reject_app_embed(app, :image)

    event.message.delete
    reject = event.send_embed("", embed)

    Emoji::IMG_APP.each do |reaction|
      reject.react(reaction)
    end

    reject.react(Emoji::CHECK)
    reject.react(Emoji::CROSS)

  when [:image_rejection, :check]
    user = event.server.member(UID.match(app.description)[1])
    embed = user_img_app(event)

    event.message.delete
    bot.send_temporary_message(event.channel.id, "", 5, false, embed)
    bot.send_message(user.dm.id, "", false, embed)
  when [:image_rejection, :cross]
    event.message.delete

  when [:item_application, :yes]
    item = ItemController.edit_item(app)
    embed = item_embed(item)

    event.message.delete
    #bot.send_message(ENV['CHAR_CH'], "New Item!", false, embed)
  when [:item_application, :no]
    embed = reject_app_embed(app)

    event.message.delete
    reject = event.send_embed("", embed)

    reject.react(Emoji::CRAYON)
    reject.react(Emoji::CROSS)
  when [:item_rejection, :crayon]
    embed = self_edit_embed(app, Url::ITEM)

    event.message.delete
    bot.send_temporary_message(event.channel.id, "", 25, false, embed)
  when [:item_rejection, :cross]
    event.message.delete

  when [:member, :picture]
    event.message.delete_all_reactions
    char = Character.find(carousel.char_id)
    img = ImageController.img_scroll(
      char_id: char.id,
      nsfw: event.channel.nsfw?,
    )
    carousel.update(id: carousel.id, image_id: img&.id)
    user =
      case
      when char.user_id.match(/public/i)
        "Public"
      when member = event.server.member(char.user_id)
        member
      else
        nil
      end


    embed = character_embed(
      char: char,
      img: img,
      user: user,
      color: CharacterController.type_color(char),
      section: :image,
      event: event
    )
    event.message.edit("", embed)
    arrow_react(event.message)
  when [:member, :bags]
    emoji = Emoji::BAGS
    users = event.message.reacted_with(emoji)
    users.each do |user|
      event.message.delete_reaction(user.id, emoji) unless user.current_bot?
    end

    char = Character.find(carousel.char_id)
    user =
      case
      when char.user_id.match(/public/i)
        "Public"
      when member = event.server.member(char.user_id)
        member
      else
        nil
      end

    embed = character_embed(
      char: char,
      img: CharImage.where(char_id: char.id).find_by(keyword: 'Default'),
      user: user,
      color: CharacterController.type_color(char),
      section: :bags,
      event: event
    )
    event.message.edit("", embed)
  when [:member, :family]
  when [:member, :eyes]
    emoji = Emoji::EYES
    users = event.message.reacted_with(emoji)
    users.each do |user|
      event.message.delete_reaction(user.id, emoji) unless user.current_bot?
    end

    char = Character.find(carousel.char_id)
    color = CharacterController.type_color(char)
    user =
      case
      when char.user_id.match(/public/i)
        "Public"
      when member = event.server.member(char.user_id)
        member
      else
        nil
      end

    embed = if char.rating == 'NSFW' && !event.channel.nsfw?
              nsfw_char_embed(char: char, user: user, color: color, event: event)
            else
              character_embed(
                char: char,
                img: CharImage.where(char_id: char.id).find_by(keyword: 'Default'),
                user: user,
                color: color,
                section: :default,
                event: event
              )
            end

    event.message.edit("", embed)

  when [:member, :bust]
    event.message.delete_all_reactions
    char = Character.find(carousel.char_id)
    chars = []
    actives = []

    embed = case char.user_id
            when /pulic/i, /server/i
              chars = Character.all

              char_list_embed(chars)
            else
              chars = Character.where(user_id: char.user_id)
              user = event.server.member(char.user_id)
              actives = Character.where(user_id: char.user_id, active: 'Active')
              ids = actives.map(&:id)

              carousel.update(options: ids)
              user_char_embed(chars, user)
            end

    event.message.edit("", embed)
    option_react(event.message, actives) unless actives.empty?

  when [:member, :back]
    event.message.delete_all_reactions
    char = Character.find(carousel.char_id)
    color = CharacterController.type_color(char)
    user =
      case
      when char.user_id.match(/public/i)
        "Public"
      when member = event.server.member(char.user_id)
        member
      else
        nil
      end

    embed = if char.rating == 'NSFW' && !event.channel.nsfw?
              nsfw_char_embed(char: char, user: user, color: color, event: event)
            else
              character_embed(
                char: char,
                img: CharImage.where(char_id: char.id).find_by(keyword: 'Default'),
                user: user,
                color: color,
                section: :default,
                event: event
              )
            end

    event.message.edit("", embed)
    section_react(event.message)
  when [:member, :left], [:member, :right]
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
    user =
      case
      when char.user_id.match(/public/i)
        "Public"
      when member = event.server.member(char.user_id)
        member
      else
        nil
      end


    embed = character_embed(
      char: char,
      img: img,
      user: user,
      color: CharacterController.type_color(char),
      section: :image,
      event: event
    )
    event.message.edit("", embed)

  when [:member, :number]
    char_index = nil
    emote = nil

    Emoji::NUMBERS.each.with_index do |emoji, i|
      if reactions[emoji]&.count.to_i > 1
        char_index = i
        emote = emoji
      end
    end

    if char_index && carousel&.options
      event.message.delete_all_reactions

      char = Character.find(carousel.options[char_index])
      carousel.update(id: carousel.id, char_id: char.id)
      color =  CharacterController.type_color(char)
      user =
        case
        when char.user_id.match(/public/i)
          "Public"
        when member = event.server.member(char.user_id)
          member
        else
          nil
        end

      embed = if char.rating == 'NSFW' && !event.channel.nsfw?
                nsfw_char_embed(char: char, user: user, color: color, event: event)
              else
                character_embed(
                  char: char,
                  img: CharImage.where(char_id: char.id).find_by(keyword: 'Default'),
                  user: user,
                  color: color,
                  section: :default,
                  event: event
                )
              end

      event.message.edit("", embed)
      section_react(event.message)
    elsif char_index && carousel&.options.nil?
      users = event.message.reacted_with(emote)
      users.each do |user|
        event.message.delete_reaction(user.id, emote) unless user.current_bot?
      end

      case char_index
      when 0
        chars = Character.where(active: 'Active').order(:name)
        types = Type.all

        embed = char_list_embed(chars, 'active', types)
      when 1
        chars = Character.where(active: 'Archived').order(:name)
        types = Type.all

        embed = char_list_embed(chars, 'archived', types)
      when 2
        chars = Character
          .select('characters.*, COALESCE(r.name, r2.name) AS region')
          .joins('LEFT OUTER JOIN landmarks l on l.name = characters.location')
          .joins('LEFT OUTER JOIN regions r on r.id = l.region')
          .joins('LEFT OUTER JOIN regions r2 on characters.location = r2.name')
          .where(active: 'NPC').order(:name)

        regions = Region.all
        embed = char_list_embed(chars, 'npc', regions)
      when 3
        chars = Character.where.not(special: nil).order(:name)
        embed = char_list_embed(chars, 'special')
      end

      event.message.edit("", embed)
    end
  when [:member, :cross]
    event.message.delete
    carousel.delete

  when [:landmark, :books]
    emoji = Emoji::BOOKS
    users = event.message.reacted_with(emoji)
    users.each do |user|
      event.message.delete_reaction(user.id, emoji) unless user.current_bot?
    end

    lm = Landmark.find(carousel.landmark_id)
    user =
      case
      when lm.user_id.match(/server/i)
        "Server Owned"
      when member = event.server.member(lm.user_id)
        member
      else
        nil
      end

    embed = landmark_embed(lm: lm, user: user, section: :history, event: event)
    event.message.edit("", embed)

  when [:landmark, :skull]
    emoji = Emoji::SKULL
    users = event.message.reacted_with(emoji)
    users.each do |user|
      event.message.delete_reaction(user.id, emoji) unless user.current_bot?
    end

    lm = Landmark.find(carousel.landmark_id)
    user =
      case
      when lm.user_id.match(/server/i)
        "Server Owned"
      when member = event.server.member(lm.user_id)
        member
      else
        nil
      end

    embed = landmark_embed(lm: lm, user: user, section: :warning, event: event)
    event.message.edit("", embed)

  when [:landmark, :map]
    emoji = Emoji::MAP
    users = event.message.reacted_with(emoji)
    users.each do |user|
      event.message.delete_reaction(user.id, emoji) unless user.current_bot?
    end

    lm = Landmark.find(carousel.landmark_id)
    user =
      case
      when lm.user_id.match(/server/i)
        "Server Owned"
      when member = event.server.member(lm.user_id)
        member
      else
        nil
      end

    embed = landmark_embed(lm: lm, user: user, section: :map, event: event)
    event.message.edit("", embed)

  when [:landmark, :houses]
    emoji = Emoji::HOUSES
    users = event.message.reacted_with(emoji)
    users.each do |user|
      event.message.delete_reaction(user.id, emoji) unless user.current_bot?
    end

    lm = Landmark.find(carousel.landmark_id)
    user =
      case
      when lm.user_id.match(/server/i)
        "Server Owned"
      when member = event.server.member(lm.user_id)
        member
      else
        nil
      end

    embed = landmark_embed(lm: lm, user: user, section: :layout, event: event)
    event.message.edit("", embed)

  when [:landmark, :people]
    emoji = Emoji::PEOPLE
    users = event.message.reacted_with(emoji)
    users.each do |user|
      event.message.delete_reaction(user.id, emoji) unless user.current_bot?
    end

    lm = Landmark.find(carousel.landmark_id)
    user =
      case
      when lm.user_id.match(/server/i)
        "Server Owned"
      when member = event.server.member(lm.user_id)
        member
      else
        nil
      end

    embed = landmark_embed(lm: lm, user: user, section: :npcs, event: event)
    event.message.edit("", embed)

  when [:landmark, :cross]
    event.message.delete
    carousel.delete

  when [:team_application, :yes]
    t = Team.find_by(name: app.title)

    if t
      t.update(description: app.description)
    else
      t = Team.create!(name: app.title, description: app.description)

      # create role
      role = event.server.create_role(
        name: t.name,
        colour: 3447003,
        hoist: true,
        mentionable: true,
        reason: "New Team"
      )
      role.sort_above(ENV['TEAM_ROLE'])
      # create channel
      channel = event.server.create_channel(
        t.name,
        parent: 455776627125780489,
        permission_overwrites: [
          { id: event.server.everyone_role.id, deny: 1024 },
          { id: role.id, allow: 1024 }
        ]
      )

      t.update(role: role.id.to_s, channel: channel.id.to_s)
      # embed
      embed = message_embed(
        "Team Approved: #{t.name}!",
        "You can join with ```pkmn-team #{t.name} | apply | character_name```"
      )

      bot.send_message(ENV['TEAM_CH'], "", false, embed)
      event.message.delete
    end
  when [:team_application, :no]
    event.message.delete

  when [:team_request, :yes]
    char_id = /\s\|\s([0-9]+)$/.match(app.footer.text)
    char = Character.find(char_id[1].to_i)
    t = Team.find_by(channel: event.message.channel.id.to_s)
    event.message.delete

    if ct = CharTeam.where(team_id: t.id).find_by(char_id: char.id)
      ct.update(active: true)
    else
      CharTeam.create(char_id: char.id, team_id: t.id)
    end
    user = event.server.member(char.user_id)
    user.add_role(t.role.to_i) if user

    embed = message_embed("New Member!", "Welcome #{char.name} to the team!")
    event.send_embed("", embed)
  when [:team_request, :no]
    char_id = /\s\|\s([0-9]+)$/.match(app.footer.text)
    char = Character.find(char_id[1])
    t = Team.find_by(channel: event.message.channel.id.to_s)

    bot.send_message(
      ENV['TEAM_CH'],
      "#{char.name} has been declined from team #{t.name}",
      false,
      nil
    )

    event.message.delete

  when [:team_chat, :pin]
    event.message.pin
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
  unless User.find_by(id: event.user.id)
    usr = User.create(id: event.user.id)
    usr.make_stats
  end
end

# This will trigger when anyone leaves the server
bot.member_leave do |event|
  updated = []
  chars = Character.where(user_id: event.user.id)
  roles = event.user.roles
  roles = roles.map{ |r| "<@#{r}>" }

  chars.each do |char|
    unless char.active == 'NPC'
      char.update(active: 'Deleted')
      char.reload
    end

    updated.push("#{char.name} -- #{char.active}")
  end

  embed = Embed.new(
    title: "I've lost track of a user!",
    description: "It seems <@#{event.user.name}>, (#{event.user.nickname}) has left the server!",
    fields: [
      { name: "```Flagging Guild Members......```", value: updated.join("\n") },
      { name: "User's Roles", value: roles.join(", ") }
    ]
  )

  bot.send_message(588464466048581632, "", false, embed)
end

# This will trigger when anyone is banned from the server
bot.user_ban do |event|
end

# This will trigger when anyone is un-banned from the server
bot.user_unban do |event|
end

bot.run
