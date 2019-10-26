class ItemController
  def self.edit_item(app)
    item_hash = Item.from_form(app)

    if item = Item.find_by(edit_url: item_hash["edit_url"])
      item.update!(item_hash)
      item.reload
    else
      item = Item.create(item_hash)
    end

    item
  end
end
