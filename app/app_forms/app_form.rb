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
end
