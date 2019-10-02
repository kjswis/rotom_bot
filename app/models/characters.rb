class Character < ActiveRecord::Base
  validates :user_id, presence: true
  validates :name, presence: true
  validates :species, presence: true
  validates :types, presence: true

  def self.from_form(params)
    key_mapping = {
      "_New Character Application_" => "active",
      "Submitted by" => "user_id",
      " >>> **Characters Name**" => "name",
      "**Species**" => "species",
      "**Type**" => "types",
      "**Age**" => "age",
      "**Weight**" => "weight",
      "**Height**" => "height",
      "**Gender**" => "gender",
      "**Sexual Orientation**" => "orientation",
      "**Relationship Status**" => "relationship",
      "**Attacks**" => "attacks",
      "**Likes**" => "likes",
      "**Dislikes**" => "dislikes",
      "**Personality**" => "personality",
      "**Hometown**" => "hometown",
      "**Warnings**" => "warnings",
      "**Rumors**" => "rumors",
      "**Backstory**" => "backstory",
      "**Other**" => "other",
      "**Rating**" => "rating",
      "**Current Location**" => "location",
      "**DM Notes**" => "dm_notes",
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

    params.map do |item|
      next if item.empty?

      key,value = item.split(": ")
      db_column = key_mapping[key]

      if db_column == "active" && value == "Personal Character"
        hash[db_column] = "Active"
      elsif v = value.match(/<@([0-9]+)>/)
        hash[db_column] = v[1]
      else
        hash[db_column] = value
      end
    end

    hash = hash.reject { |k,v| k == nil }
    hash
  end

  def self.check_user(event)
    content = event.message.content
    edit_url = /Edit\sKey\s\(ignore\):\s([\s\S]*)/.match(content)
    active = /\_New\sCharacter\sApplication\_:\s(.*)/.match(content)
    user_id = /<@([0-9]+)>/.match(content)

    user = User.find_by(id: user_id[1])
    member = event.server.member(user_id[1])
    if user && member

      if active[1] == "Personal Character"
        allowed_characters = (user.level / 10 + 1)
        characters = Character.where(user_id: user_id[1]).where(active: "Active").count

        if characters < allowed_characters && characters < 6
          approval_react(event)
        else
          too_many(event, member, edit_url, 'characters')
        end
      else
        approval_react(event)
      end
    else
      unknown_member(event)
    end
  end
end
