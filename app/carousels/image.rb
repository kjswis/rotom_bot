require './app/models/carousels.rb'
require './lib/emoji.rb'

class ImageCarousel < Carousel
  def self.sections
    {
      Emoji::UNDO => 'back',
      Emoji::LEFT => 'left',
      Emoji::RIGHT => 'right'
    }
  end

  def self.update_embed(event, carousel)
    # Save reactions and determine section
    reactions = event.message.reactions
    direction = sections.filter{ |k,v| reactions[k]&.count.to_i > 1 }.values.first

    # Close if X is chosen
    return carousel.close(event) if reactions[Emoji::CROSS]&.count.to_i > 1

    case direction
    when 'back'
      # Find Image
      image = CharImage.find(carousel.image_id)
      character = Character.find(image.char_id)

      # Transition into an ImageCarousel
      event.message.delete_all_reactions
      CharacterCarousel.transition(event, carousel, character)
    when 'left', 'right'
      # Fetch the corresponding emoji, and remove non-bot reactions
      emoji = sections.key(direction)
      event.message.reacted_with(emoji).each do |r|
        event.message.delete_reaction(r.id, emoji) unless r.current_bot?
      end

      # Find image
      image = CharImage.find(carousel.image_id)
      new_image = ImageController.img_scroll(
        char_id: image.char_id,
        nsfw: event.channel.nsfw?,
        img: image.id,
        dir: direction.to_sym
      )

      # Update Carousel
      carousel.update(image_id: new_image&.id)

      # Update embed with new image
      BotResponse.new(
        carousel: carousel,
        embed: character_embed(
          character: Character.find(image.char_id),
          event: event,
          section: 'image',
          image: new_image
        )
      )
    end
  end

  def self.transition(event, carousel, character)
    # Find image ID
    image = CharImage.where(keyword: 'Default').find_by(char_id: character.id)

    # Update carousel to reflect new information
    carousel.update(
      char_id: nil,
      image_id: image&.id,
      landmark_id: nil,
      options: nil
    )

    # Array of section reactions and an X
    img_reactions = sections.map{ |k,v| k }
    img_reactions.push(Emoji::CROSS)

    # Update reply
    BotResponse.new(
      carousel: carousel,
      reactions: img_reactions,
      embed: character_embed(
        character: character,
        event: event,
        section: 'image'
      )
    )
  end
end
