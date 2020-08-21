require './app/commands/base_command.rb'

class HelpCommand < BaseCommand
  def self.opts
    {
      usage: {
        command: "Searches for a command based on its name, the part that " +
        "comes after `pkmn-`. If no command is given, R0ry will list available commands"
      }
    }
  end

  def self.cmd
    desc = "Displays helpful information for R0ry's commands"

    @cmd ||= Command.new(:help, desc, opts) do |event, command|
      # Short name for the command requested, if exists
      cmd_name = command.match(/(pkmn-)?(\w+)/)[2] if command
      all_cmds = BaseCommand.descendants

      # --Execution--
      # When a command is specified
      case command
      when /admin/i && event.channel.id == ENV['ADMIN_CH']
      when nil
        # List of commands, by restrictions: server, and pm
        server_commands = all_cmds.filter{ |bc| bc.restricted_to == nil }
        pm_commands = all_cmds.filter{ |bc| bc.restricted_to == :pm }

        reply = []
        reply.push(BotResponse.new(embed: command_list_embed(pm_commands, :pm)))
        reply.push(BotResponse.new(embed: command_list_embed(server_commands)))

        reply

      else
        # Find the command, and display
        cmd = all_cmds.find { |bc| bc.name == cmd_name.to_sym }
        command_help(cmd, event)

      end
    rescue
      command_error("Command not found!", HelpCommand)
    end
  end

  def self.example_command(event=nil)
    case ['', 'command'].sample
    when ''
      []
    when 'command'
      [BaseCommand.descendants.sample.name]
    end
  end
end
