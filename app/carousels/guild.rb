class GuildCarousel < Carousel
  def self.update_embed(event, carousel)
    # Save reactions and determine section
    reactions = event.message.reactions
    reaction = Emoji::NUMBERS.filter{ |n| reactions[n]&.count.to_i > 1 }.first
    list_index = Emoji::NUMBERS.index(reaction)

    # Close if X is chosen
    return carousel.close(event) if reactions[Emoji::CROSS]&.count.to_i > 1

    embed =
      case list_index
      when 0
        char_list_embed(
          Character.where(active: 'Active').order(:name),
          'active',
          Type.all
        )
      when 1
        char_list_embed(
          Character.where(active: 'Archived').order(:name),
          'archived',
          Type.all
        )
      when 2
        char_list_embed(
          Character.select('characters.*, COALESCE(r.name, r2.name) AS region')
          .joins('LEFT OUTER JOIN landmarks l on l.name = characters.location')
          .joins('LEFT OUTER JOIN regions r on r.id = l.region')
          .joins('LEFT OUTER JOIN regions r2 on characters.location = r2.name')
          .where(active: 'NPC').order(:name),
          'npc',
          Region.all
        )
      when 3
        adoptables = Character.where(user_id: 'Public').order(:name)
        specials = Character.where.not(special: nil).order(:name)

        char_list_embed(specials + adoptables, 'special')
      end

    # Remove reaction
    event.message.reacted_with(reaction).each do |r|
      event.message.delete_reaction(r.id, reaction) unless r.current_bot?
    end

    BotResponse.new(carousel: carousel, embed: embed)
  end
end
