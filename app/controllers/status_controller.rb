class StatusController
  def self.edit_status(name, effect)
    if status = Status.find_by(name: name)
      status.update!(effect: effect)
      status.reload
    else
      status = Status.create(name: name, effect: effect)
    end

    status
  end

  def self.edit_char_status(status, amount, char)
    char_st = CharStatus.where(char_id: char.id).find_by(status_id: status.id)
    amt = amount.to_i

    if char_st && amt
      char_st.update(amount: char_st.amount + amt)
      char_st.reload

      char_st
    elsif amt
      CharStatus.create(
        char_id: char.id,
        status_id: status.id,
        amount: amt
      )
    else
      error_embed("Amount must be numerical!")
    end
  end
end
