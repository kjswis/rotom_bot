class CharacterController
  def self.edit_character(params)
    char_hash = Character.from_form(params)

    if char = Character.find_by(edit_url: char_hash["edit_url"])
      char.update!(char_hash)
      character = Character.find_by(edit_url: char_hash["edit_url"])
    else
      character = Character.create(char_hash)
    end

    character
  end
end
