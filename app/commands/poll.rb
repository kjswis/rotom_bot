require './app/commands/base_command.rb'

class PollCommand < BaseCommand
  def self.opts
    {
      usage: {
        question: "The Question for people to vote on",
        options: "The answers to choose from, separated by commas. Each answer " +
        "will be assigned a cooresponding letter for users to vote with. Maxiumum 20 options"
      }
    }
  end

  def self.cmd
    desc = "Creates a dynamic poll in any channel"

    @cmd ||= Command.new(:poll, desc, opts) do |event, question, options|
      # Split choices into an array
      choices = options.split(/\s?,\s?/)

      # Reply
      raise 'Need voting options!' if choices.empty?
      BotResponse.new(
        embed: new_poll(event, question, choices),
        reactions: Emoji::LETTERS.take(choices.count)
      )
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.example_command(event=nil)
    [
      ["What's your favorite cake?", "Chocolate, Red Velvet, Ice Cream, Cookie, The Cake is a lie"],
      ["Who would win in an Epic Rap Battle?", "Alina, Aster, Cecil, Jaki, Kipper, Someone Else (#poll-chat-sfw)"],
      ["The best admin/moderator is..", "Neiro, Mizu, Lunick, Alina, Viewer, Vul, R0ry, He who must not be named"],
      ["The best pokemon generation is", "Kanto, Johto, Hoenn, Sinnoh, Unova, Kalos, Alola, Galar"],
      ["What is the answer to the ultimate question of life, the universe, and everything?", "What?, 42"]
    ].sample
  end
end
