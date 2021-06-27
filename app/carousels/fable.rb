require './app/models/carousels.rb'

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

    carousel.update(fable_id: fable.id)
    carousel.reload

    # Update to new fable
    BotResponse.new(
      carousel: carousel,
      embed: fable_embed(fable, event)
    )
  end

  def self.next_fable(section, carousel)
    # The list of fables in order, and the index of the current fable
    fables = Fable.order('id ASC')
    i = fables.map(&:id).index(carousel.fable_id)

    case section
    when 'first'
      fables.first
    when 'left'
      i == 0 ? fables.last : fables[i-1]
    when 'right'
      i == fables.length-1 ? fables.first : fables[i+1]
    when 'last'
      fables.last
    end
  end
end
