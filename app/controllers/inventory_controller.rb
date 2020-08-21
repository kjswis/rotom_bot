class InventoryController
  def self.edit_inventory(item, amount, character, event)
    # Find the inventory if it exists
    inventory = Inventory.where(char_id: character.id).find_by(item_id: item.id)

    # Calculate new amount of items in inventory
    new_amount = inventory ? inventory.amount + amount : amount

    if new_amount > 0 && inventory
      # Update row
      inventory.update(amount: new_amount)
      character_embed(character: character, event: event, section: :bags)
    elsif new_amount > 0
      # Create new row
      Inventory.create(char_id: character.id, item_id: item.id, amount: new_amount)
      character_embed(character: character, event: event, section: :bags)
    elsif new_amount == 0
      # Delete row
      inventory.destroy
      character_embed(character: character, event: event, section: :bags)
    elsif new_amount < 0
      # Error
      error_embed("Error!", "Negative total #{item.name} result")
    end
  end
end
