require 'bundler'
require 'erb'
require 'yaml'
require 'json'
require 'terminal-table'
require 'rmagick'
require "down"

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
    color: event.author.color.combined,
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
stats = Command.new(:stats, desc, opts) do |event, name|

  case name
  when UID
    user_id = UID.match(name)
    user = event.server.member(user_id[1])
    user_url = user.avatar_url if user
  when String
    #See if you can find the name some other way?
  end

  channel = event.channel.id
  size_width = 570;
  size_height = 376;
  stats_frame =  "images/LevelUp.png"
  level_up = "images/LevelUpFont.png"
  user_url_img = "images/Image_Builder/user_url_img.png"
  output_file =  "images/Image_Builder/LevelUp"

  Down.download(user_url, destination: user_url_img)

  #Gif Destroyer
  i = Magick::ImageList.new(user_url_img)
  binding.pry

  if(i.count > 1)
    i[0].write(user_url_img);
  end
  #End Gif Destroyer

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

  # C# code for getting the percantage to the next level
    #int levelprior = LevelUp[task].NextLevel - (10 * (LevelUp[task].CurrentLevel - 1) ^ 2);
    #double ratio = (double)(LevelUp[task].Messages - levelprior) / (double)(LevelUp[task].NextLevel - levelprior);

  ratio = 0.5

  gc = Draw.new

  gc.font('OpenSans-SemiBold.ttf')

  gc.stroke('#39c4ff').fill('#39c4ff')
  gc.rectangle(42, 48, 42 + (95 * ratio), 48 + 3)

  gc.stroke('none').fill('black')
  gc.pointsize('15')
  name_sm = "Test Name 1"
  gc.text(15,25, name_sm)
  level = 'Lv.4'
  gc.text(40, 45, level)
  level_rank = 'Rank 104'
  gc.text(15, 290, level_rank)
  exp = '12340'
  gc.text(40, 65, exp)

  gc.stroke('white').fill('white')
  gc.pointsize('30')
  name_lg = "Test Name 2"
  gc.text(40,330, name_lg)
  reached = "reached level 4!"
  gc.text(40,360, reached)

  gc.stroke('none').fill('black')
  gc.pointsize('18')
  lvl_max_hp = '10'
  gc.text(450, 97, lvl_max_hp)
  lvl_atk = '11'
  gc.text(450, 127, lvl_atk)
  lvl_def = '12'
  gc.text(450, 159, lvl_def)
  lvl_sp_atk = '13'
  gc.text(450, 191, lvl_sp_atk)
  lvl_sp_def = '14'
  gc.text(450, 222, lvl_sp_def)
  lvl_speed = '15'
  gc.text(450, 255, lvl_speed)

  gc.stroke('none').fill('maroon')
  iv_max_hp = '+10'
  gc.text(505, 97, iv_max_hp)
  iv_atk = '+11'
  gc.text(505, 127, iv_atk)
  iv_def = '+12'
  gc.text(505, 159, iv_def)
  iv_sp_atk = '+13'
  gc.text(505, 191, iv_sp_atk)
  iv_sp_def = '+14'
  gc.text(505, 222, iv_sp_def)
  iv_speed = '+15'
  gc.text(505, 255, iv_speed)

  u = Magick::ImageList.new("#{output_file}.png")
  gc.draw(u[0])

  u.write("#{output_file}.png")

  msg = bot.send_file(channel, File.open("#{output_file}.png", 'r'))

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
  color = user.color.combined if user.color
  chars = []

  character =
    if user.roles.map(&:name).include?('Guild Masters')
      chars = Character.where(name: name)
      chars.first if chars.length == 1
    else
      Character.where(user_id: user.id).find_by(name: name) if name
    end
  active = status.match(/(in)?active/i) if status

  case
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
    embed = new_app_dm(user_name, user.id, color)

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
      user = char.user_id.match(/public/i) ?
        char.user_id : event.server.member(char.user_id)
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

item = Command.new(:item, desc, opts) do |event, name|
  i = name ? Item.find_by!(name: name.capitalize) : Item.all

  case
  when name && i
    item_embed(i)
  when !name && i
    item_list_embed(i)
  else
    command_error_embed("Error proccessing your request!", item)
  end
rescue ActiveRecord::RecordNotFound
  error_embed("Item Not Found!")
end

desc = "Add and remove items from characters' inventories"
opts = { "item | (-/+) amount | character" => "" }
inv = Command.new(:inv, desc, opts) do |event, item, amount, name|
  char = Character.find_by!(name: name) if name
  itm = Item.find_by!(name: item) if item
  amt = amount.to_i

  case
  when char && itm && amt
    i = Inventory.update_inv(itm, amt, char)
    user = event.server.member(char.user_id.to_i)
    color = CharacterController.type_color(char)

    case i
    when Inventory, true
      character_embed(char: char, user: user, color: color, section: :bags)
    when Embed
      i
    else
      error_embed("Something went wrong!", "Could not update inventory")
    end
  else
    command_error_embed("Could not proccess your request", inv)
  end
rescue ActiveRecord::RecordNotFound => e
  error_embed(e.message)
end

desc = "Update or edit statuses"
opts = { "name | effect" => "" }
status = Command.new(:status, desc, opts) do |event, name, effect|
  if name && effect
    s = StatusController.edit_status(name, effect)

    case s
    when Status
      success_embed("Created Status: #{name}")
    when Embed
      s
    end
  else
    command_error_embed("Could not create status!", status)
  end
end

opts = { "character | ailment | %afflicted" => "" }
afflict = Command.new(:afflict, desc, opts) do |event, name, status, amount|
  char = Character.find_by!(name: name) if name
  st = Status.find_by!(name: status) if status

  user = char.user_id.match(/public/i) ?
    'Public' : event.server.member(char.user_id)

  if st && amount && char
    user = char.user_id.match(/public/i) ?
      'Public' : event.server.member(char.user_id)
    color = CharacterController.type_color(char)

    s = StatusController.edit_char_status(st, amount, char)

    case s
    when CharStatus
      character_embed(char: char, user: user, color: color, section: :status)
    when Embed
      s
    end
  else
    command_error_embed("Error afflicting #{char}", afflict)
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
      character_embed(char: char, user: user, color: color, section: :status)
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
  "team_name | create | description" => "admin only command"
}
team = Command.new(:team, desc, opts) do |event, team_name, action, desc|
  unless action&.match(/create/i)
    t = Team.find_by!(name: team_name) if team_name

    char = if event.author.roles.map(&:name).include?('Guild Masters')
             Character.find_by!(name: desc) if desc
           else
             c = Character.where(user_id: event.author.id).find_by!(name: desc)
             ct = CharTeam.where(char_id: c.id).find_by(active: true)
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
      user.remove_role(t.role.to_i) if user
    end
    bot.send_message(
      t.channel.to_i,
      "#{char.name} has left the team",
      false,
      nil
    )
  when /apply/i
    members = CharTeam.where(team_id: t.id)
    if members.count >= 6
      embed = team_app_embed(t, char, event.server.member(char.user_id))
      msg = bot.send_message(t.channel.to_i, "", false, embed)

      msg.react(Emoji::Y)
      msg.react(Emoji::N)
      success_embed("Your request has been posted to #{t.name}!")
    else
      error_embed("#{t.name} is full!")
    end
  when /create/i
    team_name = team_name || ""
    desc = desc || ""

    embed = new_team_embed(event.message.author, team_name, desc)
    msg = bot.send_message(ENV['APP_CH'], "", false, embed)

    msg.react(Emoji::Y)
    msg.react(Emoji::N)
    success_embed("Your Team Application has been submitted!")
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
<<<<<<< 77a766d541086a3ee08efe0eebbbcad8820c7865
  status,
  afflict,
  cure,
  team,
||||||| merged common ancestors
  weather,
=======
>>>>>>> level up
  stats
]

#locked_commands = [inv]

# This will trigger on every message sent in discord
bot.message do |event|
  content = event.message.content
  author = event.author.id

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
  elsif command && !cmd && event.server
    event.send_embed(
      "",
      error_embed("Command not found!")
    )
  elsif author == ENV['WEBHOOK'].to_i
    app = event.message.embeds.first
    if app.author.name == 'Character Application'
      Character.check_user(event)
    else
      approval_react(event)
    end
  #elsif content == 'test'
    #User.import_user(File.open('users.txt', 'r'))
  elsif content == 'pry'
    binding.pry
  elsif content == 'show me dem illegals'
    users = User.all
    illegals = []

    users.each do |u|
      allowed = u.level / 10 + 1
      active = Character.where(user_id: u.id, active: 'Active').count
      illegals.push("<@#{u.id}>, Level #{u.level}: #{active}/#{allowed}") if active > allowed
    end
    embed = error_embed("Members with too many pokemon", illegals.join("\n"))
    event.send_embed("", embed)
  elsif !event.author.current_bot?
    usr = User.find_by(id: author.to_s)
    msg = URL.match(content) ? content.gsub(URL, "x" * 149) : content

    usr = usr.update_xp(msg)
    event.respond(usr) if usr.is_a? String
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

  app = event.message.embeds.first
  carousel = Carousel.find_by(message_id: event.message.id)

  carousel = Carousel.find_by(message_id: event.message.id)
  maj = 100

  form =
    case app.author&.name
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
    else
      :carousel if carousel
    end

  vote =
    case
    when reactions[Emoji::Y]&.count.to_i > maj.round then :yes
    when reactions[Emoji::N]&.count.to_i > maj.round then :no
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
    when reactions.any? { |k,v| Emoji::NUMBERS.include? k } then :number
    end

  case [form, vote]
  when [:character_application, :yes]
    uid = UID.match(app.description)
    user =
      app.description.match(/public/i) ? 'Public' : event.server.member(uid[1])

    char = CharacterController.edit_character(app)
    img = ImageController.default_image(
      app.thumbnail.url,
      char.id
    )if app.thumbnail
    color = CharacterController.type_color(char)

    embed = character_embed(
      char: char,
      img: img,
      user: user,
      color: color
    )if char

    if embed
      bot.send_message(
        ENV['CHAR_CH'].to_i,
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
                ENV['CHAR_CH_NSFW'].to_i
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
    bot.send_message(ENV['CHAR_CH'], "New Item!", false, embed)
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

  when [:carousel, :notebook]
    emoji = Emoji::NOTEBOOK
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
      section: :image
    )
    event.message.edit("", embed)
    arrow_react(event.message)
  when [:carousel, :bags]
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
      section: :bags
    )
    event.message.edit("", embed)
  when [:carousel, :family]
  when [:carousel, :eyes]
    emoji = Emoji::EYES
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
      section: :default
    )
    event.message.edit("", embed)
  when [:carousel, :back]
    event.message.delete_all_reactions
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
        section: :default
      )
      event.message.edit("", embed)
      section_react(event.message)
    end
  when [:carousel, :cross]
    event.message.delete
    carousel.delete

  when [:team_application, :yes]
    t = Team.create!(name: app.title, description: app.description)

    # create role
    role = event.server.create_role(
      name: t.name,
      colour: 3447003,
      hoist: true,
      mentionable: true,
      reason: "New Team"
    )
    #role.sort_above(ENV['TEAM_ROLE'])
    # create channel
    channel = event.server.create_channel(
      t.name,
      parent: 642055732321189928,
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
  unless User.find_by(id: event.author.id.to_s)
    usr = User.create(id: event.author.id.to_s)
    usr.make_stats
  end
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
