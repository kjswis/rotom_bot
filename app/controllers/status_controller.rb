class StatusController
  def self.edit_status(name, effect, flag=nil)
    if status = Status.find_by(name: name)
      status.update!(effect: effect, amount: flag)
      status.reload
    else
      flag = flag ? flag : true
      status = Status.create(name: name, effect: effect, amount: flag)
    end

    status
  end

  def self.edit_char_status(char, status, amount=nil)
    char_st = CharStatus.where(char_id: char.id).find_by(status_id: status.id)
    amt = amount.to_i if amount

    if char_st && amt && status.amount
      char_st.update(amount: char_st.amount + amt)
      char_st.reload

      char_st
    elsif char_st && !status.amount
      error_embed("The user is already afflicted with #{status.name}")
    elsif amount && !amt && status.amount
      error_embed("Amount must be numerical!")
    elsif amt && status.amount
      CharStatus.create(
        char_id: char.id,
        status_id: status.id,
        amount: amt
      )
    elsif !status.amount
      CharStatus.create(
        char_id: char.id,
        status_id: status.id,
      )
    end
  end
end
