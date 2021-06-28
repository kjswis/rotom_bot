class Modal < ActiveRecord::Base
  validates :message_id, presence: true

  def interact(event)
  end

  def close(event)
    self.destroy
    event.message.delete
  end
end
