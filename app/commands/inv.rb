require './app/commands/base_command.rb'

class InventoryCommand < BaseCommand
  def self.opts
    {
      usage: {
        item: "Searches for an item by name",
        amount: "Specifies the amount of the item to add or remove",
        character: "Searches for your character by the specified name"
      }
    }
  end

  def self.cmd
    desc = "Add and remove items from characters' inventories"

    @cmd ||= Command.new(:inv, desc, opts) do |event, item, amount, name|
      # Find character and item
      character = Character.restricted_find(name, event.author, ['Archived'])
      item = Item.find_by!('name ilike ?', item)

      # Return if amount is not a number
      raise 'Invalid Amount!' if amount.to_i == 0
      InventoryController.edit_inventory(item, amount.to_i, character, event)

    rescue ActiveRecord::RecordNotFound => e
      error_embed(e.message)
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.example_command(event=nil)
    [
      Item.order('RANDOM()').first.name,
      ["-#{rand(1 .. 5)}", rand(1 .. 5)].sample,
      Character.where.not(active: 'Deleted').order('RANDOM()').first.name
    ]
  end
end
