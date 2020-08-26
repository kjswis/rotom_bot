require './app/commands/base_command.rb'

class MemberCommand < BaseCommand
  def self.opts
    {
      # Nav consists of reaction sections and descriptions
      nav: {
        all: [ Emoji::EYES, "View all info about the character" ],
        image: [ Emoji::PICTURE, "Scroll though the character's images" ],
        bags: [ Emoji::BAGS, "View the character's inventory" ],
        family: [ Emoji::FAMILY, "View related characters" ],
        user: [ Emoji::BUST, "View the writer's other characters in a list" ]
      },
      # Usage has each option, in order with instructions, and a real example
      usage: {
        name:
        "Searches characters for the specified name, or discord user. " +
        "If no name is given, R0ry will show a list of all characters",
        section:
        "Skips to the specified section, some options include: bio, type, status, " +
        "rumors, image, bags. If no section is given, R0ry will default to history",
        keyword:
        "Displays a specific image, searched by its title, or keyword. " +
        "Can only be used if the section option is `image`",
      }
    }
  end

  def self.cmd
    desc = "Display info about the guild members"

    @cmd ||= Command.new(:member, desc, opts) do |event, name, section, keyword|
      # Determine display type: user, character, or list
      case name
      # Show user's character list
      when UID
        # Find User to display, and a list of their characters
        member = event.server.member(UID.match(name)[1])
        characters = Character.where(user_id: UID.match(name)[1])
        active_chars = characters.filter{ |c| c.active == 'Active' }

        # Handle sfw channels and nsfw characters
        sfw = !event.channel.nsfw?
        sfw_chars = active_chars.filter{ |c| c.rating != 'NSFW' }
        chars = sfw ? sfw_chars : active_chars

        # Generate embed and reply
        BotResponse.new(
          embed: user_char_embed(characters, member, sfw),
          carousel: active_chars.map(&:id),
          reactions: Emoji::NUMBERS.take(chars.count).push(Emoji::CROSS)
        )

      # Show Character List Embed
      when nil
        # Grab list of active characters, and types
        characters = Character.where(active: 'Active').order(:name)
        types = Type.all

        # Create reaction list
        reactions = Emoji::NUMBERS.take(4)

        # Generate embed, and reply
        BotResponse.new(
          embed: char_list_embed(characters, 'active', types),
          reactions: reactions.push(Emoji::CROSS),
          carousel: 'Guild'
        )

      # Show character embed
      when Integer
        # Find Character by ID and generate embed
        character = Character.find(name)
        char_reply(event, character, section, keyword)
      else
        # Find Character by name and generate embed
        character = Character.where('name ilike ?', name)
        raise 'Character not found!' if character.empty?
        char_reply(event, character, section, keyword)
      end

    rescue ActiveRecord::RecordNotFound => e
      error_embed("Record Not Found!", e.message)
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.char_reply(event, character, section, keyword)
    # Current channel restricted?
    sfw = !event.channel.nsfw?

    # Determine if duplicate characters, then filter NSFW if SFW channel
    if character.count > 1
     chars = character.filter{ |c| c.rating == 'SFW' || c.rating == 'Hidden' } if sfw

     # If still more than 1 character, reply with duplicate embed
     if chars.length > 1
       embed = dup_char_embed(chars, chars.first.name)
       return BotResponse.new(
         embed: embed,
         reactions: Emoji::NUMBERS.take(chars.count),
         carousel: chars.map(&:id)
       )
     end
    end

    character = character.first

    # Find image if specified
    image = CharImage.where(char_id: character.id).
      find_by('keyword ilike ?', keyword || 'Default')

    # Ensure the content is appropriate for the current channel
    if sfw && ( image&.category == 'NSFW' || character.rating == 'NSFW' )
      return nsfw_char_embed(character, event)
    end

    # Generate Character Embed
    embed = character_embed(
      character: character,
      event: event,
      section: section,
      image: image
    )

    # Determine Carousel Type and create reply
    if section&.match(/images?/i)
      BotResponse.new(
        embed: embed,
        carousel: image,
        reactions: ImageCarousel.sections.map{ |k,v| k }.push(Emoji::CROSS)
      )
    else
      BotResponse.new(
        embed: embed,
        carousel: character,
        reactions: CharacterCarousel.sections.map{ |k,v| k }.push(Emoji::CROSS)
      )
    end
  end

  def self.example_command(event=nil)
    sections = ['all', 'bio', 'type', 'status', 'rumors', 'image', 'bags']

    case ['', 'user', 'name', 'section', 'keyword'].sample
    when ''
      []
    when 'user'
      user = Character.where(active: 'Active').order('RANDOM()').first.user_id
      member = event&.server&.member(user)
      ["@#{member&.nickname || member&.name || 'user_name'}"]
    when 'name'
      [Character.where.not(active: 'Deleted').order('RANDOM()').first.name]
    when 'section'
      [Character.where.not(active: 'Deleted').order('RANDOM()').first.name,
       sections.sample]
    when 'keyword'
      i = CharImage.where.not(keyword: 'Default').order('RANDOM()').first
      [Character.find(i.char_id).name, 'image', i.keyword]
    end
  end
end
