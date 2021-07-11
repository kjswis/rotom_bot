class ItemController
  def self.edit_item(app)
    item_hash = Item.from_form(app)

    if item = Item.find_by(edit_url: item_hash["edit_url"])
      item.update(item_hash)
      item.reload
    else
      item = Item.create(item_hash)
    end

    item
  end

  def self.diff(params)
    return unless old_app = Item.find_by(edit_url: params.footer.text)

    new_app = Item.new(Item.from_form(params))
    Item::MAPPING.map{ |k,v| k if old_app[v] != new_app[v] }.reject{ |a| a == nil }
  end
end
