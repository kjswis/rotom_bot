require './app/commands/base_command.rb'

class StatsCommand < BaseCommand
  def self.opts
    {
      usage: {
        user: "Searches for a discord user (need to @ them)",
        all: "Used to specify you'd like to view all stats, instead of level" +
        " progress. If empty, will show level image"
      }
    }
  end

  def self.cmd
    desc = "Shows a user's stats, level, rank, and experience"

    @cmd ||= Command.new(:stats, desc, opts) do |event, name, all|
      if name.match(/ghosts?/i) && Util::Roles.admin?(event.author)
        return UserController.fetch_ghost_users(event)
      end

      # Find appropriate User and Server Member
      user = User.find(UID.match(name)[1])
      member = event.server.member(UID.match(name)[1])

      case all
      when /all/i
        # Display all User stats
        show_stats(user, member)
      when /reroll/i
        if Util::Roles.admin?(event.author)
          # Generate new stats
          user.make_stats
          user.reload

          # Display
          show_stats(user, member)
        else
          # Can only re-roll if admin
          error_embed("Not Authorized!")
        end
      else
        # Generate stats image, and reply
        output_file = UsersController.stat_image(user, member)
        BotResponse.new(destination: event.channel.id, file: output_file)
      end

    rescue ActiveRecord::RecordNotFound => e
      error_embed(e.message)
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.example_command(event)
    user_id = Character.where(active: 'Active').order('RANDOM()').first.user_id
    member = event&.server&.member(user_id)
    member_name = member&.nickname || member&.name || 'user_name'

    case ['', 'all'].sample
    when ''
      ["@#{member_name}"]
    when 'all'
      ["@#{member_name}", "all"]
    end
  end

  def self.admin_opts
    {
      usage: {
        user: "@user",
        reroll: "Reroll will reroll user's stats"
      }
    }
  end
end
