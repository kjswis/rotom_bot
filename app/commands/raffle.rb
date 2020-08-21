class RaffleCommand < BaseCommand
  def self.opts
    {
      usage: {
        participats: "Chooses a random winner from a list of names. " +
        "Also accepts everyone and here to pull names from server members"
      }
    }
  end

  def self.cmd
    desc = "Creates a raffle and picks a winner"

    @cmd ||= Command.new(:raffle, desc, opts) do |event, participant|
      # Collect participants
      participants =
        case participant
        when /^everyone$/i
          event.server.members
        when /^here$/i
          event.message.channel.users
        else
          participant.split(/\s?,\s?/)
        end

      # Pick winner and format
      winner = participants.sample
      results = winner&.id ? "<@#{winner.id}>" : winner.capitalize

      # Reply
      Embed.new(description: "#{results} has won the raffle!")
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.example_command(event=nil)
    list = [
      'Neiro, Mizu, Lunick, Alina, Viewer, Vul',
      'Cecil, Aster, Zel, Rezi, Vern, Sarah, Bernie',
      'Apple, Cherry, Strawberry, Lemon, Chocolate',
      'Eevee, Vaporeon, Flareon, Jolteon, Espeon, Umbreon, Glaceon, Leafeon, Sylveon',
      'Sword, Sheild, Gun, Bomb, Tank, Fighter Jet'
    ].sample

    [ ['everyone'], ['here'], [list] ].sample
  end
end
