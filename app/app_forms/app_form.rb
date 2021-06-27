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
      to_office(event, ENV['MIZ_OFFICE'])
    elsif reactions[Emoji::FISH]&.count.to_i > 0
      to_office(event, ENV['NEI_OFFICE'])
    elsif reactions[Emoji::CAT]&.count.to_i > 0
      to_office(event, ENV['LUN_OFFICE'])
    elsif reactions[Emoji::CABINET]&.count.to_i > 0
      to_office(event, ENV['R0R_OFFICE'])
    elsif reactions[Emoji::COW]&.count.to_i > 0
      to_office(event, ENV['R0R_OFFICE'])
    elsif reactions[Emoji::TOOLS]&.count.to_i > 0
      to_office(event, ENV['MOD_CHAMBERS'])
    elsif reactions[Emoji::WEAPONS]&.count.to_i > 0
      to_office(event, ENV['KRT_CHAMBERS'])
    end
  end

  def self.approve
    raise 'nyi'
  end

  def self.deny
    raise 'nyi'
  end

  def self.majority(event)
    # the total number of voters, divided by 2
    event.server.roles.find{ |r| r.id == ENV['GMS_ROLE'].to_i }.members.count / 2
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
    app.footer = { text: 'This app is in review' }

    BotResponse.new(destination: office, embed: app)
  end
end
