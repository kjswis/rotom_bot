require './app/commands/base_command.rb'

class MatchupCommand < BaseCommand
  def self.opts
    {
      usage: {
        primary: "Searches for type by name, must be an official pokemon type",
        secondary: "Concats the second type to the first, and displays both"
      }
    }
  end

  def self.cmd
    desc = "Displays a chart of effectiveness for the given type"

    @cmd ||= Command.new(:matchup, desc, opts) do |event, primary, secondary|
      # Find the appropriate type images
      file = "images/Type #{primary.capitalize}.png"
      secondary_file = "images/Type #{secondary.capitalize}.png"

      # Combine if there are two
      if File.exists?(file) && File.exists?(secondary_file)
        append_image(file, secondary_file, 'images/Type Double.png')
        file = 'images/Type Double.png'
      end

      # Raise an error if the File does not exist, or return
      raise 'Unknown Type!' unless File.exists?(file)
      BotResponse.new(destination: event.channel.id, file: file)

    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.example_command(event=nil)
    case ['primary', 'secondary'].sample
    when 'primary'
      [Type.where.not(name: 'Unknown').order('RANDOM()').first.name]
    when 'secondary'
      type = Type.where.not(name: 'Unknown').order('RANDOM()').take(2)
      type.map(&:name)
    end
  end
end
