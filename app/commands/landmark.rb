class LandmarkCommand < BaseCommand
  def self.opts
    {
      # Nav consists of reaction sections and descriptions
      nav: {
        history: [ Emoji::BOOKS, "Learn about the history and folklore" ],
        warning: [ Emoji::SKULL, "Learn about the areas dangers" ],
        map: [ Emoji::MAP, "See the area on the map of Zaplana" ],
        layout: [ Emoji::HOUSES, "View a local map of the area" ],
        npc: [ Emoji::PEOPLE, "See the NPC residents you might meet" ]
      },
      # Usage has each option, in order with instructions, and a real example
      usage: {
        name:
        "Searches landmarks for the specified name. " +
        "If no name is given, R0ry will show a list of all landmarks",
        section:
        "Skips to the specified section, can use any section listed in " +
        "navigation. If no section is given, R0ry will default to history"
      }
    }
  end

  def self.cmd
    desc = "Learn all about the various places in Zaplana!"

    @cmd ||= Command.new(:landmark, desc, opts) do |event, name, section|

      if name
        # Find landmark, case insensitive
        landmark = Landmark.find_by!('name ilike ?', name)

        # Reply with landmark display
        BotResponse.new(
          embed: landmark_embed(lm: landmark, section: section, event: event),
          carousel: landmark,
          reactions: LandmarkCarousel.sections.map{ |k,v| k }.push(Emoji::CROSS)
        )
      else
        # Reply with landmark list display
        landmark_list
      end
    rescue ActiveRecord::RecordNotFound => e
      error_embed("Record Not Found!", e.message)
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.example_command(event=nil)
    case ['', 'name', 'section'].sample
    when ''
      []
    when 'name'
      [Landmark.order('RANDOM()').first.name]
    when 'section'
      [Landmark.order('RANDOM()').first.name,
       ['history', 'warning', 'map', 'layout', 'npc'].sample]
    end
  end
end
