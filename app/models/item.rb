class Item < ActiveRecord::Base
  validates :name, presence: true

  def self.from_form(app)
    key_mapping = {
      "Item Name" => "name",
      "Description" => "description",
      "Known Effects" => "effect",
      "Potential Side Effects" => "side_effect",
      "Limitations" => "limits",
      "Duration" => "duration",
      "RP Used Message" => "rp_use",
      "RP Find Message" => "rp_find",
      "Rating" => "rating",
      "Image URL" => "img_url",
      "Category" => "category",
      "Rarity" => "rarity",
      "Reusable" => "reusable",
      "Location" => "location",
      "Crafting Recipe" => "recipe",
      "Status List" => "statuses"
    }

    hash = {}
    app.fields.each do |field|
      next if field.nil?

      db_column = key_mapping[field.name]
      hash[db_column] =
        case db_column
        when "category"
          hash[db_column] = field.value.split(",")
        when "reusable"
          hash[db_column] = field.value == "True" ? true : false
        else
          hash[db_column] = field.value
        end
    end

    hash["name"] = app.title
    hash["description"] = app.description
    hash["url"] = app.thumbnail.url if app.thumbnail
    hash["edit_url"] = app.footer.text

    hash = hash.reject { |k,v| k == nil }
    hash
  end
end
