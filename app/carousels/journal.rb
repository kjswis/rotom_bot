require './app/models/carousels.rb'
require './lib/emoji.rb'

class JournalCarousel < Carousel
  def self.sections
    {
      Emoji::UNDO => 'back',
      Emoji::LEFT => 'left',
      Emoji::RIGHT => 'right',
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
      # Fetch character
      character = Character.find(carousel.char_id)

      # Transition into a MemberCarousel
      event.message.delete_all_reactions
      CharacterCarousel.transition(event, carousel, character)
    when 'left', 'right'
      # Fetch the correspoding emoji, and remove non-bot reactions
      emoji = sections.key(direction)
      event.message.reacted_with(emoji).each do |r|
        event.message.delete_reaction(r.id, emoji) unless r.current_bot?
      end

      # Next Journal Page
      page = JournalController.journal_scroll(
        char_id: carousel.char_id,
        page: carousel.journal_page,
        dir: direction
      )

      # Update Carousel
      carousel.update(char_id: carousel.char_id, journal_page: page)

      # Update embed with new page
      BotResponse.new(
        carousel: carousel,
        embed: character_embed(
          character: Character.find(carousel.char_id),
          event: event,
          section: 'journal',
          journal: JournalController.fetch_page(carousel.char_id, page)
        )
      )
    end
  end

  def self.transition(event, carousel, character)
    # Fetch inital page of journals
    journals = JournalController.fetch_page(character.id, 1)

    # Update carousel to reflect new information
    carousel.update(
      char_id: character.id,
      image_id: nil,
      landmark_id: nil,
      options: nil,
      journal_page: 1
    )

    # Update Reply
    BotResponse.new(
      carousel: carousel,
      reactions: sections.map{ |k,v| k }.push(Emoji::CROSS),
      embed: character_embed(
        character: character,
        event: event,
        section: 'journal',
        journal: journals
      )
    )
  end
end
