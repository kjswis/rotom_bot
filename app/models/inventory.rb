class Inventory < ActiveRecord::Base
  validates :item_id, presence: true

  def self.update_inv(item, amount, char)
    i = Inventory.where(char_id: char.id).find_by(item_id: item.id)

    if i.nil? && amount > 0
      Inventory.create(char_id: char.id, amount: amount, item_id: item.id)
    elsif i && i.amount + amount > 0
      i.update(amount: i.amount + amount)
      i.reload
    elsif i && i.amount + amount == 0
      i.delete
      true
    else
      error_embed(
        "Cannot update inventory!",
        "#{char.name} does not have enough #{item.name}"
      )
    end
  end
end
