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
      event.message.react("🇾")
      event.message.react("🇳")
    else
      event.server.member(user_id[1]).dm("You have too many characters!\nPlease deactivate and try again #{edit_url[1]}")
      event.message.delete
    end
  else
    event.message.edit("#{content}\n\nI don't know this user!")
  end
end

def edit_character(params, member)
  key_mapping = {
    "Submitted by" => "user_id",
    " >>> **Characters Name**" => "name",
    "**Species**" => "species",
    "**Type**" => "types",
    "**Age**" => "age",
    "**Weight**" => "weight",
    "**Height**" => "height",
    "**Gender**" => "gender",
    "**Sexual Orientation**" => "orientation",
    "**Relationship Status**" => "relationship",
    "**URL to your character's appearance**" => "image_url",
    "**Attacks**" => "attacks",
    "**Custom Attack Description**" => "custom_attack",
    "**Likes**" => "likes",
    "**Dislikes**" => "dislikes",
    "**Personality**" => "personality",
    "**Rumors**" => "rumors",
    "**Backstory**" => "backstory",
    "**Other**" => "other",
    "Edit Key (ignore)" => "edit_url",
  }

  hash = {}

  params.map do |item|
    next if item.empty?

    key,value = item.split(": ")
    db_column = key_mapping[key]

    if v = value.match(/<@([0-9]+)>/)
      hash[db_column] = v[1]
    else
      hash[db_column] = value
    end
  end

  # Should we add this to the form, and allow NPCs to be created the same way?
  hash["active"] = 'Active'

  if image_url = hash["image_url"]
    hash = hash.reject { |k| k == "image_url" }
  end

  if custom_attack = hash["custom_attack"]
    hash = hash.reject { |k| k == "custom_attack" }
  end

  if char = Character.find_by(edit_url: hash["edit_url"])
    char.update!(hash)
    character = Character.find_by(edit_url: hash["edit_url"])
  else
    character = Character.create(hash)
  end

  edit_images(image_url, character.id, 'sfw', 'primary') if image_url

  user = "#{member.name}##{member.tag}"
  character_embed(character, image_url, user)
end

def edit_images(image_url, character_id, category, keyword)
  unless Url.where(char_id: character_id).find_by(url: image_url)
    Url.create(char_id: character_id, url: image_url, category: category, keyword: keyword)
  end
end

def character_embed(character, image, user)
  fields = []

  fields.push({name: 'Species', value: character.species, inline: true}) if character.species
  fields.push({name: 'Type', value: character.types, inline: true}) if character.types
  fields.push({name: 'Age', value: character.age, inline: true}) if character.age
  fields.push({name: 'Weight', value: character.weight, inline: true}) if character.weight
  fields.push({name: 'Height', value: character.height, inline: true}) if character.height
  fields.push({name: 'Gender', value: character.gender, inline: true}) if character.gender
  fields.push({name: 'Sexual Orientation', value: character.orientation, inline: true}) if character.orientation
  fields.push({name: 'Relationship Status', value: character.relationship, inline: true}) if character.relationship
  fields.push({name: 'Attacks', value: character.attacks}) if character.attacks
  fields.push({name: 'Likes', value: character.likes}) if character.likes
  fields.push({name: 'Dislikes', value: character.dislikes}) if character.dislikes
  fields.push({name: 'Rumors', value: character.rumors}) if character.rumors
  fields.push({name: 'Backstory', value: character.backstory}) if character.backstory
  fields.push({name: 'Other', value: character.other}) if character.other

  embed = Embed.new(
    footer: {
      text: "Created by #{user} | #{character.active}"
    },
    title: character.name,
    fields: fields
  )

  embed.description = character.personality if character.personality
  embed.thumbnail = { url: image } if image

  embed
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

# ---

commands = [
  hello,
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
    check_user(event)
  end
end

# This will trigger on every reaction is added in discord
bot.reaction_add do |event|
  if event.message.author.id == APP_BOT
    yes = event.message.reacted_with("🇾").count
    no = event.message.reacted_with("🇳").count
    maj = event.server.roles.find{ |r| r.id == ADMINS }.members.count
    maj = maj / 2

    if yes > maj
      msg = event.message.content.split("\n")
      uid = /<@([0-9]+)>/.match(event.message.content)
      member = event.server.member(uid[1])

      embed = edit_character(msg, member)

      if embed
        # Bot doesn't have permission to delete messages :(
        #event.message.delete

        bot.send_message(
          CHAR_CHANNEL,
          "Character Approved!",
          false,
          embed
        )
      else
        event.respond("Something went wrong")
      end
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
