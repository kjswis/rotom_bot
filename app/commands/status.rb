class StatusCommand < BaseCommand
  def self.opts
    {
      usage: {
        name: "Searches for a status by its name. If none is specified, " +
        "R0ry displays a list of all statuses"
      }
    }
  end

  def self.cmd
    desc = "Update or edit statuses"

    @cmd ||= Command.new(:status, desc, opts) do |event, name, effect, flag|
      if effect
        # Update or create status, returns embed
        StatusController.update_status(name, effect, flag) if Util::Roles.admin?(event.author)
      else
        # Find Status, if specified
        status = Status.find_by('name ilike ?', name) if name

        # Display Status or Status List
        embed = status ? status_details(status) : status_list
        embed
      end

    rescue ActiveRecord::RecordNotFound => e
      error_embed(e.message)
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.example_command(event=nil)
    case ['', 'name'].sample
    when ''
      []
    when 'name'
      [Status.order('RANDOM()').first.name]
    end
  end

  def self.admin_opts
    {
      usage: {
        name: "The name given to the status",
        effect: "The effect to display on a user.",
        flag: "Indicates if the effect stacks, default is true"
      }
    }
  end
end
