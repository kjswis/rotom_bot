class Modal < ActiveRecord::Base
  validates :message_id, presence: true

  def self.reactions
    [Emoji::Y, Emoji::N]
  end

  def interact(event)
  end

  def update(event, type)
  end

  def close(event)
    self.destroy
    event.message.delete
  end
end
