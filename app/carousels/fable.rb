class FableCarousel < Carousel
  def self.sections
    {
      Emoji::FIRST => 'first',
      Emoji::LEFT => 'left',
      Emoji::RIGHT => 'right',
      Emoji::LAST => 'last'
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

    # Find next fable
    fable = next_fable(section, carousel)

    # Update to new fable
    BotResponse.new(
      carousel: carousel,
      embed: fable_embed(fable, event)
    )
  end

  def self.next_fable(section, carousel)
    case section
    when 'first'
      Fable.order('id DESC').first
    when 'left'
      Fable.where('id < ?', carousel.fable_id).order('id DESC').first ||
        Fable.order('id DESC').first
    when 'right'
      Fable.where('id > ?', carousel.fable_id).order('id ASC').first ||
        Fable.order('id ASC').first
    when 'last'
      Fable.order('id ASC').first
    end
  end
end
