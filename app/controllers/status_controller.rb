class StatusController
  def self.update_status(name, effect, flag=nil)
    # Find Status, if exists
    status = Status.find_by('name ilike ?', name)

    # Determine action
    case flag
    when /true/i, nil
      if effect.match(/delete/i) && status
        # Delete Status
        status.destroy
        success_embed("Destroyed #{name}")
      else
        # Update/Create then return embed
        update_or_create(status, name, effect, true)
        status_details(status)
      end

    when /false/i
      # Update/Create then return embed
      update_or_create(status, name, effect, true)
      status_details(status)

    when /delete/i, /remove/i
      # Delete Status
      status.destroy
      success_embed("Destroyed #{name}")
    end
  end

  def self.afflict_char_status(character, status, amount=nil)
    # Find the status effect if it exists
    char_status =
      CharStatus.where(char_id: character.id).find_by(status_id: status.id)

    if status.amount
      raise "#{status.name} requires an amount!" if amount == 0
      new_amount = char_status.amount + amount

      char_status.update(amount: new_amount) if char_status
    else
      CharStatus.create(
        char_id: character.id,
        status_id: status.id,
        amount: amount
      )
    end
  end

  def self.cure_char_status(character, status, amount=nil)
    case status
    when /all/i
      # Clear all status effects from the user
      CharStatus.where(char_id: character.id).destroy_all
    when Status
      # Find the status effect if it exists
      char_status =
        CharStatus.where(char_id: character.id).find_by(status_id: status.id)

      raise "Character does not have status #{status.name}!" if !char_status

      # Find new value
      if status.amount
        raise "#{status.name} requires an amount!" if amount == 0
        new_amount = char_status.amount + amount
      end

      # If the value is 0 or below, delete
      if !status.amount || new_amount == 0
        char_status.destroy
      else
        char_status.update(amount: new_amount)
      end
    end
  end

  def update_or_create(status, name, desc, amount)
    # Create or Update
    if status
      status.update(effect: effect, amount: true)
      status.reload
    else
      status = status.create(name: name, effect: effect, amount: true)
    end
  end
end
