class LandmarkCarousel < Carousel
  def self.sections
    {
      Emoji::BOOKS => 'history',
      Emoji::SKULL => 'warning',
      Emoji::MAP => 'map',
      Emoji::HOUSES => 'layout',
      Emoji::PEOPLE => 'npc'
    }
  end

  def self.update_embed(event, carousel)
    # Save reactions and determine section
    reactions = event.message.reactions
    section = sections.filter{ |k,v| reactions[k]&.count.to_i > 1 }.values.first

    # Close the embed if that is chosen
    return carousel.close(event) if reactions[Emoji::CROSS]&.count.to_i > 1

    # Fetch the corresponding emoji, and remove non-bot reactions
    emoji = sections.key(section)
    event.message.reacted_with(emoji).each do |r|
      event.message.delete_reaction(r.id, emoji) unless r.current_bot?
    end

    # Update landmark with new section
    BotResponse.new(
      carousel: carousel,
      embed: landmark_embed(
        lm: Landmark.find(carousel.landmark_id),
        section: section,
        event: event
      )
    )
  end
end
