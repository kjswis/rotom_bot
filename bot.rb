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
command_list = []

# Commands: structure basic bot commands here

command_list.push(["pkmn-hello","a simple test command to make the bot say hi."])
hello = Command.new(:hello) do |event|
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

help = Command.new(:help) do |event,extra|
  user = event.author.nickname || event.author.name
  fields = []

  command_list.each do |item|
	fields.push({name: item[0], value: item[1]})
  end

  Embed.new(
    color: "#73FE49",
    title: "List of Character Commands",
    description: "Basic list of commands and what they do!",
    fields: fields
  )
end

command_list.push(["pkmn-matchup <type>","Shows the types that are strong and weak to the given type."])
matchup = Command.new(:matchup) do |event, type|
  channel = event.channel.id
  file = "images/Type #{type.capitalize}.png"

  if File.exists?(file)
    bot.send_file(channel, File.open(file, 'r'))
  else
    bot.respond("I do not know this pokemon type! Please try again!")
  end
end

command_list.insert(0,["pkmn-app <name>","Starts the process for a new character appication or to edit an existing one. Dont worry. Any other commands needed for this will be listed in the responces!"])
app = Command.new(:app) do |event, name|
  user = event.author
  user_channel = event.author.dm

  if name
    if character = Character.where(user_id: user.id).find_by(name: name)
      edit_url = APP_FORM + character.edit_url
      embed = edit_app_embed(event, edit_url, name)

      bot.send_message(user_channel.id, "", false, embed)
    else
      app_not_found_embed(event, name)
    end
  else
    embed = new_app_embed(event)
    bot.send_message(user_channel.id, "", false, embed)
  end
end

# ---

commands = [
  app,
  hello,
  help,
  matchup
]

# This will trigger on every message sent in discord
bot.message do |event|
  content = event.message.content

  if (match = /^pkmn-(\w+)/.match(content))
      command = match[1]

      if cmd = commands.detect { |c| c.name == command.to_sym }
        reply = cmd.call(content, event)

        if reply.is_a? Embed
          event.send_embed("", reply)
        elsif reply
          event.respond(reply)
        else
          event.respond("Something went wrong!")
        end
      end
  end

  if event.author.id == APP_BOT
    Character.check_user(event)
  end

end

# This will trigger when a dm is sent to the bot from a user
bot.pm do |event|
end

# This will trigger when any reaction is added in discord
bot.reaction_add do |event|
  content = event.message.content

  if event.message.author.id == APP_BOT
    maj = event.server.roles.find{ |r| r.id == ADMINS }.members.count / 2
    maj = 1

    if event.message.reacted_with(Emoji::Y).count > maj
      params = content.split("\n")
      uid = UID.match(content)
      member = event.server.member(uid[1])

      character = CharacterController.edit_character(params)
      image_url = ImageController.edit_images(content, character.id)

      embed = character_embed(character, image_url, member)

      if embed
        event.message.delete

        bot.send_message(
          CHAR_CHANNEL,
          "Character Approved!",
          false,
          embed
        )
      else
        event.respond("Something went wrong")
      end

    elsif event.message.reacted_with(Emoji::N).count > maj
      embed = reject_char_embed(content)
      reject_app(event, embed)
    end
  end

  if event.message.from_bot? && content.match(/\_New\sCharacter\sApplication\_/)
    if event.message.reacted_with(Emoji::CHECK).count > 1
      user_id = UID.match(content)
      member = event.server.member(user_id[1])

      embed = message_user_embed(event)

      event.message.delete
      bot.send_temporary_message(event.channel.id, "", 5, false, embed)

      user_channel = member.dm
      bot.send_message(user_channel.id, "", false, embed)

    elsif event.message.reacted_with(Emoji::CROSS).count > 1
      event.message.delete
    elsif event.message.reacted_with(Emoji::CRAYON).count > 1
      embed = self_edit_embed(content)

      event.message.delete
      bot.send_temporary_message(event.channel.id, "", 35, false, embed)
    end
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
