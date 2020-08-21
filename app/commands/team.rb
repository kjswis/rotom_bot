require './app/commands/base_command.rb'

class TeamCommand < BaseCommand
  def self.opts
    {
      usage: {
        team: "Searches for a team by it's name. If no team is specified, " +
        "R0ry will display a list of all teams.",
        action: "Accepts `create` to create a new team, " +
        "`update` inside a team's private channel to update team information, " +
        "`apply` to request for a character to join the team, and " +
        "`leave` to have a character leave the team",
        argument: "If creating or updating a team, this should be the description" +
        " for the team. If applying for or leaving a team, this should be your " +
        "character's name"
      }
    }
  end

  def self.cmd
    desc = "Rescue Teams: view, create, update, join or leave teams"

    @cmd ||= Command.new(:team, desc, opts) do |event, team_name, action, desc|
      # Save author
      author = event.author

      # --Execute--
      case action
      # New Team Request
      when /create/i
        raise 'Team Already Exists' if Team.find_by(name: team_name)
        reply = []

        # Request Team to Admin
        reply.push(BotResponse.new(
          destination: ENV['APP_CH'],
          embed: create_request(team_name, desc),
          reactions: Emoji::REQUEST
        ))

        # Sucess message to submitter
        reply.push(BotResponse.new(
          embed: success_embed("Your request for a new team has been submitted for approval!")
        ))

      # Existing Team Update
      when /update/i
        # Find appropriate team
        team = Team.find_by!(channel: event.channel.id)

        # Update team with new info
        team.update(name: team_name, description: desc)
        team.reload

        # Reply with new team info
        team_embed(team)

      # Team Join Request
      when /apply/i
        # Find appropriate team
        team = Team.find_by!('name ilike ?', team_name)

        # Find character, check if eligable
        char = Character.restricted_find(desc, author, ['Archived'])
        in_team = CharTeam.where(char_id: char.id).find_by(active: true)

        # Ensure if user is eligable
        if User.find(event.author.id).level < 5
          error_embed("You are not high enough level!")

        # Ensure team has open slots
        elsif CharTeam.where(team_id: team.id, active: true).count >= 6
          error_embed("#{team.name} is full!")

        # Ensure character is not in team or an admin
        elsif in_team && !Util::Roles.admin?(author)
          error_embed("#{char.name} is already in a team!")

        else
          # Character's creator [discord user]
          member = event.server.member(char.user_id.to_i)
          reply = []

          # Request message to team
          reply.push(BotResponse.new(
            destination: team.channel.to_i,
            embed: join_request(char, member),
            reactions: Emoji::REQUEST
          ))

          # Success message to sumbitter
          reply.push(BotResponse.new(
            embed: success_embed("Your request was sent to #{team.name}!")
          ))

          reply
        end

      # Member Leave Team
      when /leave/i
        # Find appropriate team
        team = Team.find_by!('name ilike ?', team_name)

        # Find character
        char = Character.restricted_find(desc, author, ['Archived'])

        # Remove character from team
        # Response indicates if user needs a role removed
        case team.leave(char)
        when Embed
          error_embed("Character not in Team!")
        when true
          user = event.server.member(char.user_id.to_i)
          user.remove_role(team.role.to_i)

          # Reply to alert team of member leave
          BotResponse.new(
            destination: team.channel.to_i,
            text: "#{char.name} has left the team"
          )
        when false
          # Reply to alert team of member leave
          BotResponse.new(
            destination: team.channel.to_i,
            text: "#{char.name} has left the team"
          )
        else
          error_embed("Something Went Wrong!")
        end

      # Disband Team
      when /archive/i, /disband/i
        # Find the team
        team = Team.find_by!(channel: event.channel.id)

        # Update team to inactive
        CharTeam.where(team_id: team.id).update(active: false)
        team.update(active: false)

        # Delete Role and archive channel
        event.server.role(team.role).delete('Archived Team')
        event.channel.category=(ENV['TEAM_ARCHIVES'])

        success_embed("Successfully Archived #{team.name}")

      # Display Team Info
      when nil
        team = Team.find_by!('name ilike ?', team_name) if team_name
        team_name ? team_embed(team) : teams_embed
      else
        command_error_embed("Could not process team request!", team)
      end

    rescue ActiveRecord::RecordNotFound => e
      error_embed("Record Not Found!", e.message)
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.example_command(event=nil)
    sample_team = [
      [ 'Hotel California', "You can checkout any time you like, but you can never leave~" ],
      [ 'The Jungle Team', "We've got fun and games. We've got everything you want!" ],
      [ 'Team Sudden Stop', "We are a great team full of many young adventures just looking for a g-" ],
      [ 'Little Nightmares', "Come play with us! *Forever, and ever and e v e r . . ." ],
      [ 'Puppo Pals', "Bork bork! Woof?" ]
    ].sample

    case ['', 'team', 'create', 'update', 'apply', 'leave'].sample
    when ''
      []
    when 'team'
      [Team.where(active: true).order('RANDOM()').first.name]
    when 'create'
      [sample_team[0], 'create', sample_team[1]]
    when 'update'
      [sample_team[0], 'update', sample_team[1]]
    when 'apply'
      [Team.where(active: true).order('RANDOM()').first.name,
       'apply',
       Character.where(active: 'Active').order('RANDOM()').first.name]
    when 'leave'
      [Team.where(active: true).order('RANDOM()').first.name,
       'leave',
       Character.where(active: 'Active').order('RANDOM()').first.name]
    end
  end

  def self.admin_opts
    {
      usage: {
        team: 'Team name, irrelevant, but must be done in team chat',
        action: 'Archive/Disband'
      }
    }
  end
end
