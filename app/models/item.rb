class Item < ActiveRecord::Base
  validates :name, presence: true

  def self.from_form(app)
    key_mapping = {
      "Item Name" => "name",
      "Description" => "description",
      "Effect" => "effect",
      "Side Effect" => "side_effect",
      "RP Reply" => "rp_reply",
      "Category" => "category",
      "Reusable" => "reusable"
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
