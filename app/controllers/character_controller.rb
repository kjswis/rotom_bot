class CharacterController
  def self.edit_character(params)
    char_hash = Character.from_form(params)

    if character = Character.find_by(edit_url: char_hash["edit_url"])
      character.update(char_hash)
      character.reload
    else
      character = Character.create(char_hash)
    end

    character
  end

  def self.authenticate_char_app(event)
    # Save application embed
    app = event.message.embeds.first

    # Nothing to check if the character is public, already active, or not a PC
    return true if app.description.match(/(public|server)/i) ||
      Character.find_by(edit_url: app.footer.text)&.active == 'Active' ||
      !app.title.match('Personal Character')

    # Save the user id, and find the db user, and discord member
    user_id = UID.match(app.description)
    user = User.find(user_id[1])
    member = event.server.member(user_id[1])

    # Count the active characters, and subtract from their allowed max
    chars = Character.where(active: 'Active', user_id: user.id).count
    if user.allowed_chars(member) - chars > 0
      true
    else
      false
    end
  rescue ActiveRecord::RecordNotFound => e
    error_embed("Record not Found!", e.message)
  rescue StandardError => e
    error_embed(e.message)
  end

  def self.diff(params)
    return unless old_app = Character.find_by(edit_url: params.footer.text)

    new_app = Character.new(Character.from_form(params))
    Character::MAPPING.map{ |k,v| k if old_app[v] != new_app[v] }.reject{ |a| a == nil }
  end
end
