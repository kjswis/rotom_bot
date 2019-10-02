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

matchup = Command.new(:matchup) do |event, type|
  channel = event.channel.id
  file = "images/Type #{type.capitalize}.png"

  if File.exists?(file)
    bot.send_file(channel, File.open(file, 'r'))
  else
    bot.respond("I do not know this pokemon type! Please try again!")
  end
end

app = Command.new(:app) do |event, name|
  user = event.author

  if name
    if character = Character.where(user_id: user.id).find_by(name: name)
      edit_url = APP_FORM + character.edit_url
      event.respond("OK, #{user.name}! I'll send you what you need to edit #{name}")
      user.dm("You may edit #{name} here:\n#{edit_url}")
    else
      event.respond("I didn't find your character, #{name}\nIf you want to start a new app, please use `pkmn-app`")
    end
  else
    event.respond("You want to start a new character application?\nGreat! I'll dm you instructions")
    user.dm("Hi, #{user.name}\nYou can start your application here:\n#{APP_FORM}\n\nYour key is: #{user.id}\nOnce complete, your application will submitted to the admins for approval!")
  end
end

# ---

commands = [
  hello,
  matchup,
  app
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

# This will trigger on every reaction is added in discord
bot.reaction_add do |event|
  content = event.message.content

  if event.message.author.id == APP_BOT
    maj = event.server.roles.find{ |r| r.id == ADMINS }.members.count / 2
    maj = 1

    if event.message.reacted_with(Emoji::Y).count > maj
      params = content.split("\n")
      uid = /<@([0-9]+)>/.match(content)
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
      edit_url = /Edit\sKey\s\(ignore\):\s([\s\S]*)/.match(content)
      user_id = /<@([0-9]+)>/.match(content)

      new_message = "#{user_id[1]}:#{edit_url[1]}"
      embed = reject_char_embed(content)

      #event.message.delete
      rejected = event.send_embed(content, embed)

      rejected.react(Emoji::SPEECH_BUBBLE)
      rejected.react(Emoji::SCALE)
      rejected.react(Emoji::PICTURE)
      rejected.react(Emoji::BOOKS)
      rejected.react(Emoji::BABY)
      rejected.react(Emoji::SKULL)
      rejected.react(Emoji::VULGAR)
      rejected.react(Emoji::NOTE)
      rejected.react(Emoji::CHECK)
      rejected.react(Emoji::CROSS)
      rejected.react(Emoji::CRAYON)

    end
  end

  if event.message.from_bot? && content.match(/\_New\sCharacter\sApplication\_/)
    if event.message.reacted_with(Emoji::CHECK).count > 1
      reactions = event.message.reactions

      edit_url = /Edit\sKey\s\(ignore\):\s([\s\S]*)/.match(content)
      user_id = /<@([0-9]+)>/.match(content)
      member = event.server.member(user_id[1])

      message = "Your application has been rejected!"

      Emoji::APP_SECTIONS.each do |reaction|
        if reactions[reaction].count > 1
          m = CharAppResponses::REJECT_MESSAGES[reaction].gsub("\n", " ")
          message += "\n#{m}"
        end
      end

      #event.message.delete
      event.send_temporary_message(message, 25)

      message += "\n\nYou may edit your application and resubmit here:\n#{APP_FORM}#{edit_url[1]}"
      member.dm(message)

    elsif event.message.reacted_with(Emoji::CROSS).count > 1
      event.message.delete
    elsif event.message.reacted_with(Emoji::CRAYON).count > 1
      edit_url = /Edit\sKey\s\(ignore\):\s([\s\S]*)/.match(content)

      message = "Please edit the users application and resubmit!\n#{APP_FORM}#{edit_url[1]}"

      #event.message.delete
      event.send_temporary_message(message, 25)
    end
  end
end

# This will trigger on every reaction is removed in discord
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
