class Character < ActiveRecord::Base
  validates :user_id, presence: true
  validates :name, presence: true
  validates :species, presence: true
  validates :types, presence: true

  def self.from_form(app)
    key_mapping = {
      "Characters Name" => "name",
      "Species" => "species",
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
      "Other" => "other",
      "Rating" => "rating",
      "Current Location" => "location",
      "DM Notes" => "dm_notes",
      "Edit Key (ignore)" => "edit_url",
    }

    hash = {
      "user_id" => nil,
      "name" => nil,
      "species" => nil,
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
      "other" => nil,
      "edit_url" => nil,
      "active" => nil,
      "dm_notes" => nil,
      "location" => nil,
      "rumors" => nil,
      "hometown" => nil,
      "warnings" => nil,
      "rating" => nil
    }

    user_id = UID.match(app.description)
    active = app.title == "Personal Character" ? 'Active' : 'NPC'

    hash["user_id"] = user_id[1]
    hash["active"] = active

    app.fields.each do |field|
      next if field.nil?

      db_column = key_mapping[field.name]
      hash[db_column] = field.value
    end

    hash = hash.reject { |k,v| k == nil }
    hash
  end

  def self.check_user(event)
    app = event.message.embeds.first

    edit_url = app.footer.text
    active = app.title
    user_id = UID.match(app.description)

    user = User.find_by(id: user_id[1])

    if user
      member = event.server.member(user_id[1])

      calc_max = (user.level / 10 + 1)
      allowed_chars = calc_max > 6 ? 6 : calc_max
      active_chars =
        Character.where(user_id: user_id[1]).where(active: "Active")
      active_chars = active_chars.map(&:edit_url)

      new_active =
        active == "Personal Character" && !active_chars.include?(edit_url)

      too_many = new_active ? active_chars.count >= allowed_chars : false
    end

    if user && member
      too_many ?
        too_many(event, member, edit_url, 'characters') : approval_react(event)
    else
      unknown_member(event)
    end
  end
end
