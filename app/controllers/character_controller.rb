class CharacterController
  def self.edit_character(params)
    char_hash = Character.from_form(params)

    if character = Character.find_by(edit_url: char_hash["edit_url"])
      character.update!(char_hash)
      character.reload
    else
      character = Character.create(char_hash)
    end

    character
  end

  def self.type_color(char)
    char_type = char.types.split("/").first || "Unknown"
    type = Type.find_by(name: char_type)

    type.color
  end
end
