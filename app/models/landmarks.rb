class Landmark < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :category, presence: true
  before_save :set_default_warning

  def set_default_warning
    if warning.nil?
      warning = "This is a verified safe location!"
      w_url = "https://cdn.dribbble.com/users/250235/screenshots/2850450/pokemon_center_1x.png"
      w_rating = "SFW"
    end
  end

  def self.from_form(app)
    key_mapping = {
      "Description" => "description",
      "Type" => "category",
      "Main Region" => "region",
      "Parent Landmark" => "location",
      "Kinks" => "kink",
      "Warning Description" => "warning",
      "Warning URL" => "w_url",
      "Warning Rating" => "w_rating",
      "History" => "history",
      "Folklore" => "folk_lore",
      "Layout URL" => "layout_url"
    }

    hash = {
      "name" => nil,
      "description" => nil,
      "category" => nil,
      "url" => nil,
      "location" => nil,
      "region" => nil,
      "warning" => nil,
      "w_url" => nil,
      "kink" => nil,
      "layout_url" => nil,
      "user_id" => nil,
      "w_rating" => nil,
      "history" => nil,
      "folk_lore" => nil,
      "edit_url" => nil
    }

    user_id = UID.match(app.description)
    hash["user_id"] = case app.description
                      when /server/i
                        'Server'
                      else
                        user_id[1]
                      end

    hash["name"] = app.title
    hash["edit_url"] = app.footer.text
    hash["url"] = app.image&.url

    app.fields.each do |field|
      next if field.nil?

      db_column = key_mapping[field.name]
      if db_column == "region"
        r = Region.find_by(name: field.value)
        hash[db_column] = r.id
      elsif db_column == "location"
        lm = Landmark.find_by(name: field.value)
        hash[db_column] = lm.id
      elsif db_column == "kink"
        hash[db_column] = field.value.split(/,\s?/)
      else
        hash[db_column] = field.value
      end
    end

    hash = hash.reject { |k,v| k == nil }
    hash
  end
end
