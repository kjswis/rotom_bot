require './app/commands/base_command.rb'

class FableCommand < BaseCommand
  def self.opts
    {
      usage: {
        title: "Searches for the fable by title or keyword. If none is given, " +
        "R0ry will start with the first story"
      }
    }
  end

  def self.cmd
    desc = 'The book of Zaplanic Myths, Fables, and Legends'

    @cmd ||= Command.new(:fable, desc, opts) do |event, title|
      case title
      when /all/i
      when String
        # Search for Fable
        fable =
          Fable.find_by('title ilike ?', title) ||
          Fable.where('? ilike any(keywords)', title) if title

        raise 'Fable not found' if fable.empty?

        # Display
        #embed = fable.lenth > 1 ? fable_list(fable) : fable_embed(fable, event)
        BotResponse.new(
          embed: fable_embed(fable.first, event),
          carousel: fable.first,
          reactions: FableCarousel.sections.map{ |k,v| k }.push(Emoji::CROSS)
        )
      when nil
        # Display first Fable
        fable = Fable.first
        BotResponse.new(
          embed: fable_embed(fable, event),
          carousel: fable,
          reactions: FableCarousel.sections.map{ |k,v| k }.push(Emoji::CROSS)
        )

      end

    rescue ActiveRecord::RecordNotFound => e
      error_embed("Record Not Found!", e.message)
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.example_command(event=nil)
    case ['', 'title', 'keyword'].sample
    when ''
      []
    when 'title'
      [Fable.order('RANDOM()').first.name]
    when 'keyword'
      [Fable.order('RANDOM()').first.keywords.sample]
    end
  end
end
