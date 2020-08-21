require './app/commands/base_command.rb'

class ItemCommand < BaseCommand
  def self.opts
    {
      usage: {
        name: "Search for an item by its name. If none is specified, " +
        "R0ry will display a list of all items"
      }
    }
  end

  def self.cmd
    desc = "Learn about Items"

    @cmd ||= Command.new(:item, desc, opts) do |event, name|
      if name
        # Single item embed
        item_embed(Item.find_by!('name ilike ?', name), event)
      else
        # Item list embed
        item_list
      end
    #rescue ActiveRecord::RecordNotFound
      #error_embed("Item Not Found!")
    #rescue StandardError => e
      #error_embed(e.message)
    end
  end

  def self.example_command(event=nil)
    case ['', 'item'].sample
    when ''
      []
    when 'item'
      [Item.order('RANDOM()').first.name]
    end
  end
end
