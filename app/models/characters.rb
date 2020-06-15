class Character < ActiveRecord::Base
  validates :user_id, presence: true
  validates :name, presence: true
  validates :species, presence: true
  validates :types, presence: true

  def self.from_form(app)
    key_mapping = {
      "Characters Name" => "name",
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
      "Edit Key (ignore)" => "edit_url",
    }

    hash = {
      "user_id" => nil,
      "name" => nil,
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
      "rating" => nil
    }

    user_id = UID.match(app.description)
    active = case app.title
             when /Personal Character/
               'Active'
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

      db_column = key_mapping[field.name]

      if db_column == 'shiny'
        hash[db_column] = field.value.match(/yes/i) ? true : false
      else
        hash[db_column] = field.value
      end
    end

    hash = hash.reject { |k,v| k == nil }
    hash
  end

  def self.check_user(event)
    app = event.message.embeds.first

    edit_url = app.footer.text
    active = app.title
    user_id = UID.match(app.description)

    if app.description.match(/public/i) || app.description.match(/server/i)
      approval_react(event)
      return
    end

    user = User.find_by(id: user_id[1])
    member = event.server.member(user_id[1]) if user

    allowed_chars = (user.level / 10 + 1) if user

    if member
      allowed_chars += 1 if member.roles.map(&:name).include?("Nitro Booster")
    end

    if user
      active_chars =
        Character.where(user_id: user_id[1]).where(active: "Active")

      new_active =
        active == "Personal Character" && !active_chars.map(&:edit_url).include?(edit_url)

      too_many = new_active ? active_chars.count >= allowed_chars : false
      approval_react(event) unless too_many

      too_many(event, member, edit_url, 'characters') if too_many && member
    else
      unknown_member(event)
    end
  end
end
