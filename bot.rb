require 'bundler'
require 'erb'
require 'yaml'
require 'json'
require 'terminal-table'

BOT_ENV = ENV.fetch('BOT_ENV') { 'development' }
Bundler.require(:default, BOT_ENV)

require 'active_record'

# Constants: such as roles and channel ids

# Users
APP_BOT = 627702340018896896

# Roles
ADMINS = 308250685554556930

# Channels
CHAR_CHANNEL = 594244240020865035

# Images
HAP_ROTOM = "https://static.pokemonpets.com/images/monsters-images-800-800/479-Rotom.png"

# URLs
APP_FORM = "https://docs.google.com/forms/d/e/1FAIpQLSfryXixX3aKBNQxZT8xOfWzuF02emkJbqJ1mbMGxZkwCvsjyA/viewform"

# Regexes
UID = /<@([0-9]+)>/
EDIT_URL = /Edit\sKey\s\(ignore\):\s([\s\S]*)/
NEW_APP = /\_New\sCharacter\sApplication\_:\s(.*)/

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
      url: HAP_ROTOM
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
  user_channel = event.author.dm

  character = Character.where(user_id: user.id).find_by(name: name) if name
  active = status.match(/(in)?active/i) if status

  if status && active && character
    character.update!(active: active[0].capitalize)
    character.reload

    success_embed("Successfully updated #{name} to be #{active[0].downcase}")
  elsif name && character && !status
    edit_url = APP_FORM + character.edit_url
    embed = edit_app_embed(event, edit_url, name)

    bot.send_message(user_channel.id, "", false, embed)
  elsif !name && !status
    embed = new_app_embed(event, name)
    bot.send_message(user_channel.id, "", false, embed)
  else
    command_error_embed("There was an error processing your application!", app)
  end
end

poll = Command.new(:poll) do |event, options|
  new_poll_embed(event, options)
end

# ---

commands = [
  hello,
  matchup,
  app,
  help,
  poll
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

  event.send_embed("", error_embed("Command not found!")) if command && !cmd

  Character.check_user(event) if author == APP_BOT
end

# This will trigger when a dm is sent to the bot from a user
bot.pm do |event|
end

# This will trigger when any reaction is added in discord
bot.reaction_add do |event|
  content = event.message.content
  reactions = event.message.reactions

  maj = event.server.roles.find{ |r| r.id == ADMINS }.members.count / 2
  maj = 1

  form =
    case
    when event.message.author.id == APP_BOT
      :character_application
    when event.message.from_bot? && content.match(NEW_APP)
      :character_rejection
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
    end

  case [form, vote]
  when [:character_application, :yes]
    params = content.split("\n")
    uid = UID.match(content)
    member = event.server.member(uid[1])

    character = CharacterController.edit_character(params)
    image_url = ImageController.edit_images(content, character.id)

    embed = character_embed(character, image_url, member) if character
    bot.send_message(
      CHAR_CHANNEL,
      "Good news, <@#{member.id}>! Your character was approved",
      false,
      embed
    ) if embed

    event.message.delete if embed
    event.respond("", admin_error_embed("Something went wrong when saving application")) unless embed

  when [:character_application, :no]
    reject_app(event, reject_char_embed(content))

  when [:character_rejection, :check]
    member = event.server.member(UID.match(content)[1])
    embed = message_user_embed(event)

    event.message.delete
    bot.send_temporary_message(event.channel.id, "", 5, false, embed)
    bot.send_message(member.dm.id, "", false, embed)
  when [:character_rejection, :cross]
    event.message.delete

  when [:character_rejection, :crayon]
    event.message.delete
    bot.send_temporary_message(event.channel.id, "", 35, false, self_edit_embed(content))
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
