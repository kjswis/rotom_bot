require './app/commands/base_command.rb'

class JournalCommand < BaseCommand
  def self.opts
    {
      usage: {
        character: "Searches for the character by name, can only add entries for your own characters",
        title: "A title for the journal, may be blank (defaults to date)",
        entry: "The journal entry, shift+enter to start a new line and write the journal entry"
      }
    }
  end

  def self.cmd
    desc = "Create a short journal entry for a character"

    @cmd ||= Command.new(:journal, desc, opts) do |event, name, title, update|
      if name.to_i > 0
        # Find journal
        journal = JournalEntry.find(name)
        modal = Modal.find_by(message_id: event.message.id)

        case title
        when /character/i
          character = Character.restricted_find(update, event.author, ['Archived'])
          journal.update(char_id: character.id)
        when /title/i
          journal.update(title: update)
        when /entry/i
          entry = message.sub("#{message.match(/.*/)[0]}\n", "")
          journal.update(entry: entry)
        when /date/i
          journal.update(date: update)
        else
        end

        journal.reload
        modal.update(event, :journal)
      else
        # Find the character
        character = Character.restricted_find(name, event.author, ['Archived'])

        # Format and create Journal
        date = Time.now.strftime("%a, %b %d, %Y")
        message = event.message.content
        entry = message.sub("#{message.match(/.*/)[0]}\n", "")

        raise 'No Journal Entry Found!' if entry.nil?

        # Create a new Journal Entry with formatted date
        journal = JournalEntry.create(
          char_id: character.id,
          title: title,
          date: date,
          entry: entry
        )

        modal = journal
      end

      # Create response embed and reply
      BotResponse.new(
        embed: journal_modal(journal),
        reactions: JournalModal.reactions,
        modal: modal
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
