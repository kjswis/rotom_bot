class Character < ActiveRecord::Base
  validates :user_id, presence: true
  validates :name, presence: true
  validates :species, presence: true
  validates :types, presence: true

  MAPPING = {
    "Characters Name" => "name",
    "Aliases" => "aliases",
    "Nicknames" => "nicknames",
    "Species" => "species",
    "Shiny" => "shiny",
    "Type" => "types",
    "Age" => "age",
    "Weight" => "weight",
    "Height" => "height",
    "Gender" => "gender",
    "Sexual Orientation" => "orientation",
    "Relationship Status" => "relationship",
    "Attacks" => "attacks",
    "Likes" => "likes",
    "Dislikes" => "dislikes",
    "Personality" => "personality",
    "Hometown" => "hometown",
    "Warnings" => "warnings",
    "Rumors" => "rumors",
    "Backstory" => "backstory",
    "Recent Events" => "recent_events",
    "Other" => "other",
    "Rating" => "rating",
    "Current Location" => "location",
    "DM Notes" => "dm_notes",
    "Base Character ID" => "alt_form",
    "Edit Key (ignore)" => "edit_url",
  }


  def self.restricted_find(search, author, flags=[])
    # Append Deleted to flags
    flags.push('Deleted')

    # Find Character
    case search.to_i
    when 0
      where(user_id: author.id).
        where.not(active: flags).
        find_by!('name ilike ?', search)
    else
      find(search) if Util::Roles.admin?(author)
    end
  end

  def type_color
    Type.find_by(name: types.split("/").first || 'Unknown').color
  end

  def fetch_inventory
    # Fetch item names and amounts in character's inventory
    Inventory.where(char_id: id).
      joins('join items on items.id = inventories.item_id').
      pluck('amount, items.name')
  end

  def self.from_form(app)
    hash = {
      "user_id" => nil,
      "name" => nil,
      "aliases" => nil,
      "nicknames" => nil,
      "species" => nil,
      "shiny" => nil,
      "types" => nil,
      "age" => nil,
      "weight" => nil,
      "height" => nil,
      "gender" => nil,
      "orientation" => nil,
      "relationship" => nil,
      "attacks" => nil,
      "likes" => nil,
      "dislikes" => nil,
      "personality" => nil,
      "backstory" => nil,
      "recent_events" => nil,
      "other" => nil,
      "edit_url" => nil,
      "active" => nil,
      "dm_notes" => nil,
      "location" => nil,
      "rumors" => nil,
      "hometown" => nil,
      "warnings" => nil,
      "rating" => nil,
      "alt_form" => nil,
    }

    user_id = UID.match(app.description)
    active = case app.title
             when /Personal Character/
               'Active'
             when /Alternative Form/
               'Alt Form'
             when /NPC/
               'NPC'
             when /Archived Character/
               'Archived'
             end

    hash["user_id"] = case app.description
                      when /public/i
                        'Public'
                      when /server/i
                        'Server'
                      else
                        user_id[1]
                      end

    hash["active"] = active
    hash["edit_url"] = app.footer.text

    app.fields.each do |field|
      next if field.nil?

      db_column = MAPPING[field.name]

      if db_column == 'shiny'
        hash[db_column] = field.value.match(/yes/i) ? true : false
      elsif db_column == 'aliases'
        hash[db_column] = field.value.split(/\s?\|\s?/)
      elsif db_column == 'nicknames'
        hash[db_column] = field.value.split(/\s?\|\s?/)
      else
        hash[db_column] = field.value
      end
    end

    hash = hash.reject { |k,v| k == nil }
    hash
  end
end
