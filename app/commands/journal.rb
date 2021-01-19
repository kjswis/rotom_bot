require './app/commands/base_command.rb'

class JournalCommand < BaseCommand
  def self.opts
    {
      usage: {
        character: "Searches for the character by name, can only add entries for your own characters",
        title: "A title for the journal, may be blank (defaults to date)",
        entry: "The journal entry, should be a paragraph as the character might enter into a diary"
      }
    }
  end

  def self.cmd
    desc = "Create a short journal entry for a character"

    @cmd ||= Command.new(:journal, desc, opts) do |event, name, title, note|
      # Find the character
      character = Character.restricted_find(name, event.author, ['Archived'])

      # Format and create Journal
      date = Time.now.strftime("%a, %b %d, %Y")
      if !note
        note = title
        title = date
      elsif title == ''
        title = date
      end

      # Create a new Journal Entry with formatted date
      journal = JournalEntry.create(
        char_id: character.id,
        title: title,
        date: date,
        entry: note
      )

      # Create response embed and reply
      BotResponse.new(
        embed: character_embed(
          character: character,
          event: event,
          section: :journal,
          journal: journal
        )
      )

    rescue ActiveRecord::RecordNotFound => e
      error_embed("Record not Found!", e.message)
    end
  end

  def self.example_command(event)
    journal_entry_examples = [
      "Today I did a thing, and it was fun. Yay!",
      "As I walk through the valley where I harvest my grain, I take a look at my wife and realize she's very plain",
      "I want to kill a mother fucker just to see how it feels"
    ]

    [Character.where(active: 'Active').order('RANDOM()').first.name,
     journal_entry_examples.sample]
  end
end
