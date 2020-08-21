class CureCommand < BaseCommand
  def self.opts
    {
      usage: {
        character: "Searches for the character by name, can only cure your own characters",
        status: "Searches for a status effect by name",
        amount: "Removes a percentage amount of the status, should only be used if status is stackable",
      }
    }
  end

  def self.cmd
    desc = "Cure characters of afflicted statuses"

    @cmd ||= Command.new(:cure, desc, opts) do |event, name, status, amount|
      # Find the Character and Status
      character = Character.restricted_find(name, event.author, ['Archived'])
      status = Status.find_by!('name ilike ?', status) unless status.match(/all/i)

      raise 'Amount must be a positive number' if amount.to_i < 1

      # Update Status, and reload
      StatusController.update_char_status(character, status, 0 - amount.to_i)
      character.reload

      # Create character embed, and reply
      BotResponse.new(
        embed: character_embed(character: character, event: event, section: :status)
      )

    rescue ActiveRecord::RecordNotFound => e
      error_embed(e.message)
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.example_command(event=nil)
    case ['unstackable', 'stackable'].sample
    when 'unstackable'
      [Character.where(active: 'Active').order('RANDOM()').first.name,
       Status.where(amount: false).order('RANDOM()').first.name]
    when 'stackable'
      [Character.where(active: 'Active').order('RANDOM()').first.name,
       Status.where(amount: true).order('RANDOM()').first.name,
       rand(1 .. 100)]
    end
  end
end
