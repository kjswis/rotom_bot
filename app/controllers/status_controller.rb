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

  def self.update_char_status(character, status, amount=nil)
    case status
    when /all/i
      # Clear all status effects from the user
      CharStatus.where(char_id: character.id).destroy_all
    when Status
      # Find the status effect if it exists
      char_status =
        CharStatus.where(char_id: character.id).find_by(status_id: status.id)

      if char_status && status.amount
        raise 'Amount must be a number' if amount == 0
        # Update row
        new_amount = char_status.amount + amount

        if new_amount > 0
          # If the value is above 0, update
          char_status.update(amount: new_amount)
        else
          # If the value is 0 or below, delete
          char_status.destroy
        end

      elsif char_status && !status.amount
        raise 'Character already has status'
      else
        raise 'Character did not have status' if amount.to_i < 0
        # Create new row
        CharStatus.create(
          char_id: character.id,
          status_id: status.id,
          amount: amount
        )
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
