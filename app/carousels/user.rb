class UserCarousel < Carousel
  def self.update_embed(event, carousel)
    # Save reactions and determine section
    reactions = event.message.reactions
    reaction = Emoji::NUMBERS.filter{ |n| reactions[n]&.count.to_i > 1 }.first
    char_index = Emoji::NUMBERS.index(reaction)

    # Close if X is chosen
    return carousel.close(event) if reactions[Emoji::CROSS]&.count.to_i > 1

    # Find character
    character = Character.find(carousel.options[char_index])

    # Transition into a CharacterCarousel
    event.message.delete_all_reactions
    CharacterCarousel.transition(event, carousel, character)
  end

  def self.transition(event, carousel, user)
    # Character array
    all_chars = Character.where(user_id: user.id).order(:rating)

    # Handle nsfw chars in sfw channels
    active_chars = all_chars.filter{ |c| c.active == 'Active' }
    sfw_chars = active_chars.filter{ |c| c.rating != 'NSFW' }

    sfw = !event.channel.nsfw?
    chars = sfw ? sfw_chars : active_chars

    # Update carousel to reflect new information
    carousel.update(
      char_id: nil,
      image_id: nil,
      landmark_id: nil,
      options: chars.map{ |c| c.id },
      journal_page: nil
    )

    # Array of section reactions and an X
    user_reactions = Emoji::NUMBERS.take(chars.length)
    user_reactions.push(Emoji::CROSS)

    # Update reply
    member = event.server.member(user.id)
    BotResponse.new(
      carousel: carousel,
      reactions: user_reactions,
      embed: user_char_embed(all_chars, member, sfw)
    )
  end
end
