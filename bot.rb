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
Dir["/lib/*.rb"].each {|file| require file }


token = ENV['DISCORD_BOT_TOKEN']
bot = Discordrb::Bot.new(token: token)

# Methods: define basic methods here

def check_user(event)
  content = event.message.content
  edit_url = /Edit\sKey\s\(ignore\):\s([\s\S]*)/.match(content)

  if user_id = (/<@([0-9]+)>/.match(content))
    user = User.find_by(id: user_id[1])

    allowed_characters = (user.level / 10 + 1)
    characters = Character.where(user_id: user_id[1]).count

    if characters < allowed_characters && characters < 6
      event.message.react(Emoji::Y)
      event.message.react(Emoji::N)
    else
      event.server.member(user_id[1]).dm("You have too many characters!\nPlease deactivate and try again #{edit_url[1]}")
      event.message.delete
    end
  else
    event.message.edit("#{content}\n\nI don't know this user!")
  end
end

def edit_character(message, member)
  params = message.split("\n")
  char_hash = Character.from_form(params)
  image_url = /\*\*URL to the Character\'s Appearance\*\*\:\s(.*)/.match(message)

  if char = Character.find_by(edit_url: char_hash["edit_url"])
    char.update!(char_hash)
    character = Character.find_by(edit_url: char_hash["edit_url"])
  else
    character = Character.create(char_hash)
  end

  edit_images(image_url[1], character.id, 'sfw', 'primary') if image_url[1]
  character_embed(character, image_url[1], member)
end

def edit_images(image_url, character_id, category, keyword)
  unless CharImages.where(char_id: character_id).find_by(url: image_url)
    CharImages.create(char_id: character_id, url: image_url, category: category, keyword: keyword)
  end
end

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
    check_user(event)
  end

end

# This will trigger on every reaction is added in discord
bot.reaction_add do |event|
  content = event.message.content

  if event.message.author.id == APP_BOT
    maj = event.server.roles.find{ |r| r.id == ADMINS }.members.count / 2
    maj = 1

    if event.message.reacted_with(Emoji::Y).count > maj
      uid = /<@([0-9]+)>/.match(content)
      member = event.server.member(uid[1])

      embed = edit_character(content, member)

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
      message = event.message.content
      split_message = message.split("\n")

      i = 0
      split_message.each do |row|
        if row.match(/\*\*/)
          if row.match(/>>>/)
            row.insert 5, "#{Emoji::ALL[i]} "
            i += 1
          else
            row.insert 0, "#{Emoji::ALL[i]} "
            i += 1
          end
        end
      end

      edited_message = split_message.join("\n")
      new_message = "**_APPLICATION REJECTED!!_**\n--------------\n\n#{edited_message}\n\n\nPlease indicate what needs to be updated with the corresponding reactions!\nWhen you're done hit #{Emoji::CHECK}, or to dismiss hit #{Emoji::CROSS}"

      event.message.delete
      rejected = event.respond(new_message)

      j = 0
      i.times do
        rejected.react(Emoji::ALL[j])
        j += 1
      end

      rejected.react(Emoji::CHECK)
      rejected.react(Emoji::CROSS)
    end
  end

  if event.message.from_bot? && content.match(/\*\*\_APPLICATION\sREJECTED\!\!\_\*\*/)
    if event.message.reacted_with(Emoji::CHECK).count > 1
      reactions = event.message.reactions

      edit_url = /Edit\sKey\s\(ignore\):\s([\s\S]*)/.match(content)
      user_id = /<@([0-9]+)>/.match(content)
      member = event.server.member(user_id[1])

      message = "Your application has been rejected!\nPlease fix the following lines, and resubmit here:\n#{APP_FORM}#{edit_url[1]}"
      rows = reactions.count - 2
      i = 0

      rows.times do
        if reactions[Emoji::ALL[i]].count > 1
          row = /#{Emoji::ALL[i]}\s(.*)/.match(content)
          message += "\n> #{row[1]}"
        end

        i += 1
      end

      temp_message = "Your application has been rejected!\nPlease fix the following lines, and resubmit here:\n[users url goes here]"
      message = "Your application has been rejected!\nPlease fix the following lines, and resubmit here:\n#{APP_FORM}#{edit_url[1]}"

      event.message.delete
      event.send_temporary_message(temp_message, 15)

      member.dm(message)

    elsif event.message.reacted_with(Emoji::CROSS).count > 1
      event.message.delete
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
