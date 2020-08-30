class ApplicationForm
  def self.name
    process.name
  end

  def self.call(event)
    process.call(event)
  end

  def self.process
    raise 'NYI'
  end

  def self.check_votes(event, maj)
    reactions = event.message.reactions

    if reactions[Emoji::Y]&.count.to_i > maj && star(event)
      approve(event)
    elsif reactions[Emoji::N]&.count.to_i > maj
      deny(event)
    elsif reactions[Emoji::CRAYON]&.count.to_i > 1
      edit(event)
    elsif reactions[Emoji::CROSS]&.count.to_i > 1
      remove(event)
    elsif reactions[Emoji::GHOST]&.count.to_i > 0
      to_office(event, ENV['MIZU_CH'])
    elsif reactions[Emoji::FISH]&.count.to_i > 0
      to_office(event, ENV['NEIRO_CH'])
    end
  end

  def self.approve
    raise 'NYI'
  end

  def self.deny
    raise 'NYI'
  end

  def self.majority(event)
    # The total number of voters, divided by 2, +1
    (event.server.roles.find{ |r| r.id == ENV['ADMINS'].to_i }.members.count / 2) + 1
  end

  def self.star(event)
    stars = event.message.reacted_with(Emoji::STAR)
    stars.each do |star|
      member = event.server.member(star.id)
      return true if Util::Roles.admin?(member)
    end
    return false
  end

  def self.remove(event)
    crosses = event.message.reacted_with(Emoji::CROSS)
    crosses.each do |cross|
      member = event.server.member(cross.id)
      event.message&.delete unless member.current_bot?
    end
  end

  def self.to_office(event, office)
    app = Embed.convert(event.message.embeds.first)
    BotResponse.new(destination: office, embed: app)
  end
end
