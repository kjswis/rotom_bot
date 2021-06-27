require './app/commands/base_command.rb'

class ImageCommand < BaseCommand
  def self.opts
    {
      usage: {
        name: "Searches for your character, by name",
        keyword: "Searches for your character's image, by title or keyword," +
        " or specifies the title if new image. If an image exists for the" +
        " character with that name, the new flag and url will overwrite it",
        flag: "Delete indicates you want to delete the specified image." +
        " With a new image, SFW or NSFW should be used to specify image rating",
        url: "The url to the new image. This must be a direct link, so check" +
        " for a .jpg/.png or similar. Animated gifs are allowed",
      }
    }
  end

  def self.cmd
    desc = "View, add and edit your characters' images. " +
      "Usable only in a direct message with R0ry!"

    @cmd ||= Command.new(:image, desc, opts) do |event, name, keyword, tag, url, id|
      # Save the character creator's User, and find the character
      user = id ? User.find(id) : User.find(event.author.id)
      character = Character.where(user_id: user.id).find_by('name ilike ?', name)

      # Determine action, and execute
      if url
        # Error if any fields are invalid
        valid =
          keyword && url && tag&.match(/n?sfw/i)
        raise 'Invalid Parameters!' unless valid

        # Create and submit image application
        embed = CharImage.to_form(
          char: character,
          keyword: keyword,
          category: tag,
          url: url,
          user_id: user.id
        )

        [
          BotResponse.new(
            destination: ENV['APPS_CHANNEL'].to_i,
            embed: embed,
            reactions: Emoji::REQUEST
          ),
          BotResponse.new(
            embed: success_embed("Your image has been sumbitted for approval!")
          )
        ]

      elsif tag&.match(/delete/i)
        # Find character's image and destroy it
        CharImage.where(char_id: character.id).
          find_by('keyword ilike ?', keyword).destroy
        success_embed("Removed image: #{keyword}")

      elsif keyword
        # Find image, and display
        image = CharImage.where(char_id: character.id).
          find_by('keyword ilike ?', keyword)
        character_embed(
          character: character,
          event: event,
          section: :image,
          image: image
        )

      # Show all character images
      else
        image_list_embed(character, event)
      end

    rescue ActiveRecord::RecordNotFound => e
      error_embed("Record not Found!", e.message)
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.example_command(event=nil)
    kws = ['Fluffy', 'Pupper', 'Midnight Drink', 'On the prowl', 'Bork']
    image_url = "https://i.imgur.com/Xa9WgSn.jpg"

    case ['name', 'keyword', 'delete', 'update', 'url'].sample
    when 'name'
      [Character.where.not(active: 'Deleted').order('RANDOM()').first.name]
    when 'keyword'
      img = CharImage.where.not(keyword: 'Default').order('RANDOM()').first
      [Character.find(img.char_id).name, img.keyword]
    when 'delete'
      img = CharImage.where.not(keyword: 'Default').order('RANDOM()').first
      [Character.find(img.char_id).name, img.keyword, 'delete']
    when 'update'
      img = CharImage.where.not(keyword: 'Default').order('RANDOM()').first
      [Character.find(img.char_id).name, img.keyword, 'sfw', image_url]
    when 'url'
      char = Character.where.not(active: 'Deleted').order('RANDOM()').first.name
      [char, kws.sample, 'sfw', image_url]
    end
  end

  def admin_opts
    {
      usage: {
        name: "Character's name",
        keyword: "Image Keyword",
        tag: "SFW/NSFW or Delete",
        url: "Image URL",
        id: "Character's user id"
      }
    }
  end

  def self.restricted_to
    :pm
  end
end
