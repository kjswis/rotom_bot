class ApplicationCommand < BaseCommand
  def self.opts
    {
      usage: {
        type: "Specifies which type of form you're looking for. Options include:" +
        " character, and landmark. If omitted, defaults to characters",
        name: "Searches for a character or landmark belonging to the user by name",
        flag: "If a character is being updated, they may be flagged as active, archived, or deleted"
      }
    }
  end

  def self.cmd
    desc = "Create new or edit your existing applications for characters " +
      "and landmarks!"

    @cmd ||= Command.new(:app, desc, opts) do |event, type, name, status|
      # Save the requester of the app
      author = event.author

      # Determine type, if specified
      case type
      # Landmark App
      when /landmarks?/i
        # Find the Landmark, if specified
        landmark = Landmark.restricted_find(name, author) if name

        # Create a request confirmation form
        send_forms(author, :landmark, landmark)

      when /characters?/i
        character_form(event, author, name, status)
      # Default to Character App, if a type isn't specified
      else
        character_form(event, author, type, name)
      end
    rescue ActiveRecord::RecordNotFound => e
      error_embed("Record not Found!", e.message)
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  # -- Method to create replies for form requests
  def self.send_forms(author, app_type, model=nil)
    # To be shown as confirmation
    request_embed = model ?
      edit_app_request(author, model.name) :
      new_app_request(author, app_type)

    # To be DM'd to the user
    form_embed = model ?
      edit_app_form(author, model) :
      new_app_form(author, app_type)

    phone = model ? [] : [Emoji::PHONE]

    [ BotResponse.new(embed: request_embed),
      BotResponse.new(destination: author.dm, embed: form_embed, reactions: phone) ]
  end

  def self.character_form(event, author, name=nil, status=nil)
    character = Character.restricted_find(name, author) if name

    case status
    # Move character to archives
    when /inactive/i, /archived?/i
      # Check if character is in team
      in_team = CharTeam.where(active: true, char_id: character.id)

      if in_team
        teams = Team.where(id: in_team.map(&:team_id)).map(&:name)
        embed = team_alert(character, teams)

        BotResponse.new(embed: embed, reactions: Emoji::REQUEST)
      else
        character.update(active: 'Archived')
        character.reload

        embed = success_embed("Successfully archived #{character.name}")
        [ BotResponse.new(destination: ENV['APP_CH'], embed: embed),
          BotREsponse.new(embed: embed) ]
      end
    # Move character to active
    when /active/i
      # Ensure character is not active or npc
      if character.active == 'Active' || character.active == 'NPC'
        return error_embed("#{character.name} is #{character.active}")
      end

      # Determine if the user has room for another active character
      # Add 2 if user is a nitro booster, 1 if not
      user = User.find(character.user_id)
      cap = user.allowed_chars(event.server.member(user.id.to_i))
      current = Character.where(user_id: user.id, active: 'Active').count

      # If they have at least 1 open slot
      if cap - current > 0
        # Submit reactivation application
        embed = character_embed(character: character, event: event)
        embed.author = { name: "Reactivation Application" }

        [ BotResponse.new(destination: ENV['APP_CH'], embed: embed, reactions: Emoji::APPLICATION),
          BotResponse.new(embed: success_embed("Successfully requested #{character.name} to be reactivated!"))]
      # If they have no open slots
      else
        # Error
        error_embed("You can't do that", "You have too many active characters!")
      end

    # Delete* character -- not actually deleted
    when /deleted?/i
      # Check if character is in team
      in_team = CharTeam.where(active: true, char_id: character.id)

      if in_team
        # Fetch list of teams the character is in, and leave each one
        teams = Team.where(id: in_team.map(&:team_id))
        teams.each{ |t| t.leave(character) }
      end

      # Update character
      character.update(active: 'Deleted')
      character.reload

      # Create alert message
      embed = Embed.new(
        title: "Deleted #{character.name}",
        description: "This character can only be recovered by an admin"
      )

      # Reply
      [ BotResponse.new(destination: ENV['APP_CH'], embed: embed),
        BotREsponse.new(embed: embed) ]

    when /legend/i, /legendary/i
      return command_error("Uknown Status", ApplicationCommand) unless Util::Roles.admin?(author)

      # Add the flag to the character
      character.update(special: 'legend')
      character.reload

      success_embed("Updated #{character.name} to be #{status}")
    when /guild/i, /employee/i
      return command_error("Uknown Status", ApplicationCommand) unless Util::Roles.admin?(author)

      # Add the flag to the character
      character.update(special: 'guild')
      character.reload

      success_embed("Updated #{character.name} to be #{status}")
    when /nil/i, /null/i, /none/i
      return command_error("Uknown Status", ApplicationCommand) unless Util::Roles.admin?(author)

      # Remove flag from the character
      character.update(special: nil)
      character.reload

      success_embed("Updated #{character.name} to be #{status}")
    # New or edit character form
    when nil
      send_forms(author, :character, character)

    # Uknown status
    else
      command_error("Uknown Status", ApplicationCommand)

    end
  end

  def self.example_command(event=nil)
    case ['', 'type', 'name', 'flag'].sample
    when ''
      []
    when 'type'
      [['character', 'landmark'].sample]
    when 'name'
      case ['', 'character', 'landmark'].sample
      when 'landmark'
        ['landmark', Landmark.order('RANDOM()').first.name]
      when 'character'
        ['character',
         Character.where.not(active: 'Deleted').order('RANDOM()').first.name]
      else
        [Character.where.not(active: 'Deleted').order('RANDOM()').first.name]
      end
    when 'flag'
      case ['', 'character'].sample
      when ''
        [Character.where.not(active: 'Deleted').order('RANDOM()').first.name,
         ['active', 'inactive', 'archive', 'delete'].sample]
      when 'character'
        ['character',
         Character.where.not(active: 'Deleted').order('RANDOM()').first.name,
         ['active', 'inactive', 'archive', 'delete'].sample]
      end
    end
  end

  def self.admin_opts
    {
      usage: {
        id: "Character ID, name is functional if the character is yours",
        flag: "Flags: Active, Archived, Deleted, Legend, Guild, None"
      }
    }
  end
end
