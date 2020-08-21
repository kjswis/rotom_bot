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

UID = /<@\!?(\w+)>/
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

#--
# This will trigger on every message sent in discord
bot.message do |event|
  # Break if not in a server.. for some reason pms trigger here
  break if event.server.nil?

  # Save the message contents, and author
  content = event.message.content
  author = event.author
  # Attempt to match a command
  cmd = /^pkmn-(\w+)/.match(content)

  # Check for a standard command
  if cmd
    # Search for the corresponding command
    commands = BaseCommand.descendants.filter{ |bc| bc.restricted_to == nil }
    command = commands.detect{ |c| c.name == cmd[1].downcase.to_sym }

    # Call the command, and reply with its results
    reply = command&.call(content, event)
    BotController.reply(bot, event, reply)

  # Check for a form that needs to be reacted to
  elsif author.id == ENV['WEBHOOK'].to_i
    # Save the app, and check app if character
    app = event.message.embeds.first
    if app.author.name == 'Character Application'
      case reply = CharacterController.authenticate_char_app(event)
      when Embed
        BotController.application_react(event)
        BotController.reply(bot, event, reply)
      when true
        BotController.application_react(event)
      when false
        BotController.unauthorized_char_app(bot, event, member)
      end
    else
      BotController.application_react(event)
    end

  # Check for a clear command
  elsif ENV['CLEAR_CH'].include?(event.channel.id.to_s) && content.match(/^clear\schat$/i)
    msgs = event.channel.history(50).reject{ |m| m.author.webhook? }
    event.channel.delete_messages(msgs)

  # Check for no exp channels
  elsif ENV['NO_EXP_CH'].include?(event.channel.id.to_s)
    # Do nothing

  # Apply experience to non-bot users
  elsif !author.bot_account? && !author.webhook?
    # Replace any urls with 150 'x' chars
    message = URL.match(content) ? content.gsub(URL, "x" * 150) : content

    # Add 40 to the message length if there's a file
    msg_length = event.message.attachments.map(&:filename).count > 0 ?
      40 + message.length : message.length

    if msg_length >= 40
      # Wait until now to find user, so DB isn't touched for every message
      user = User.find(author.id)

      # Update User and reply with image, if there is one
      reply =  user.update_xp(msg_length, author)
      bot.send_file(event.channel.id, File.open(reply, 'r')) if reply
    end
  end

end

# This will trigger when a dm is sent to the bot from a user
bot.pm do |event|
  # Save the message contents
  content = event.message.content
  # Attempt to match a command
  cmd = /^pkmn-(\w+)/.match(content)

  # Check for a standard command
  if cmd
    # Search for the corresponding command
    commands = BaseCommand.descendants.filter{ |bc| bc.restricted_to == :pm }
    command = commands.detect{ |c| c.name == cmd[1].downcase.to_sym }

    # Call the command, and reply with its results
    reply = command&.call(content, event)
    BotController.reply(bot, event, reply)
  end
end

# This will trigger when any reaction is added in discord
bot.reaction_add do |event|
  app_form = event.message.embeds.first

  if Team.find_by(channel: event.channel.id)
    reactions = event.message.reactions
    event.message.pin if reactions[Emoji::PIN]&.count.to_i > 0
  end

  # Only do logic if this is an embed
  break unless app_form

  # Find the appropriate app type, and process
  app = ApplicationForm.descendants.detect{ |af| af.name == app_form.author&.name }
  carousel = Carousel.find_by(message_id: event.message.id)

  reply = if app then app&.call(event)
          elsif carousel then carousel.navigate(event)
          end

  if reply
    BotController.reply(bot, event, reply)
  #elsif event.message&.reactions[Emoji::CROSS]&.count
    #crosses = event.message.reacted_with(Emoji::CROSS)
    #crosses.each do |cross|
      #member = event.server.member(cross.id)
      #event.message.delete unless member.current_bot?
    #end
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
  fields = []

  chars = Character.where(user_id: event.user.id)
  roles = event.roles
  roles = roles.map{ |r| "<@#{r}>" } if roles

  chars.each do |char|
    unless char.active == 'NPC'
      char.update(active: 'Deleted')
      char.reload
    end
    ct = CharTeam.find_by(char_id: char.id)
    ct.update(active: false) if ct
    t = Team.find(ct.team_id) if ct

    bot.send_message(t.channel, "#{char.name} has left the server", false, nil) if t

    updated.push("#{char.name}, #{t.name} -- #{char.active}") if t
    updated.push("#{char.name}, no team data -- #{char.active}") if t.nil?
  end

  fields.push({
    name: "```Flagging Guild Members......```",
    value: updated.join("\n")
  }) unless updated.empty?

  fields.push({
    name: "User's Roles",
    value: roles.join(", ")
  }) unless roles.empty?

  embed = Embed.new(
    title: "I've lost track of a user!",
    description: "It seems #{event.member.mention}, (#{event.user.username}) has left the server!",
    fields: fields
  )

  # production channel
  bot.send_message(588464466048581632, "", false, embed)

  # development channel
  #bot.send_message(594244240020865035, "", false, embed)
end

# This will trigger when anyone is banned from the server
bot.user_ban do |event|
  updated = []
  fields = []

  chars = Character.where(user_id: event.user.id)
  roles = event.roles
  roles = roles.map{ |r| "<@#{r}>" } if roles

  chars.each do |char|
    unless char.active == 'NPC'
      char.update(active: 'Deleted')
      char.reload
    end
    ct = CharTeam.find_by(char_id: char.id)
    ct.update(active: false) if ct
    t = Team.find(ct.team_id) if ct

    updated.push("#{char.name}, #{t.name} -- #{char.active}") if t
    updated.push("#{char.name}, no team data -- #{char.active}") if t.nil?
  end

  fields.push({
    name: "```Flagging Guild Members......```",
    value: updated.join("\n")
  }) unless updated.empty?

  fields.push({
    name: "User's Roles",
    value: roles.join(", ")
  }) unless roles.empty?

  embed = Embed.new(
    title: "A User was forced to leave!",
    description: "It seems #{event.member.mention}, (#{event.user.username}) has been banned from the server!",
    fields: fields
  )

  # production channel
  bot.send_message(588464466048581632, "", false, embed)
end

# This will trigger when anyone is un-banned from the server
bot.user_unban do |event|
end

bot.run
