class CharacterCarousel < Carousel
  def self.sections
    {
      Emoji::EYES => 'all',
      Emoji::PICTURE => 'image',
      Emoji::NOTEBOOK => 'journal',
      Emoji::BAGS => 'bags',
      Emoji::FAMILY => 'family',
      Emoji::BUST => 'user'
    }
  end

  def self.update_embed(event, carousel)
    # Save reactions and determine section
    reactions = event.message.reactions
    section = sections.filter{ |k,v| reactions[k]&.count.to_i > 1 }.values.first

    # Close if X is chosen
    return carousel.close(event) if reactions[Emoji::CROSS]&.count.to_i > 1

    case section
    when 'image'
      # Transition into an ImageCarousel
      event.message.delete_all_reactions
      ImageCarousel.transition(event, carousel, Character.find(carousel.char_id))
    when 'journal'
      # Transition into an JournalCarousel
      event.message.delete_all_reactions
      JournalCarousel.transition(event, carousel, Character.find(carousel.char_id))
    when 'user'
      # Find User
      character = Character.find(carousel.char_id)
      user = User.find(character.user_id)

      # Transition into a UserCarousel
      event.message.delete_all_reactions
      UserCarousel.transition(event, carousel, user)
    when 'all', 'bags', 'family'
      # Fetch the corresponding emoji, and remove non-bot reactions
      emoji = sections.key(section)
      event.message.reacted_with(emoji).each do |r|
        event.message.delete_reaction(r.id, emoji) unless r.current_bot?
      end

      # Update character embed with new section
      BotResponse.new(
        carousel: carousel,
        embed: character_embed(
          character: Character.find(carousel.char_id),
          event: event,
          section: section
        )
      )
    end
  end

  def self.transition(event, carousel, character)
    # Update carousel to reflect new information
    carousel.update(
      char_id: character.id,
      image_id: nil,
      landmark_id: nil,
      options: nil,
      journal_page: nil
    )

    # Update reply
    BotResponse.new(
      carousel: carousel,
      reactions: sections.map{ |k,v| k }.push(Emoji::CROSS),
      embed: character_embed(
        character: character,
        event: event
      )
    )
  end
end
