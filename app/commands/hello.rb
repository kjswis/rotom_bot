class HelloCommand < BaseCommand
  def self.cmd
    @cmd ||= Command.new(:hello, "Says hello!") do |event|
      author = event.author.nickname || event.author.name
      img = ImageUrl.find_by(name: 'happy')

      greetings = [
        "Hi there, #{author}",
        "Greetings #{author}, you lovable bum",
        "Alola, #{author}",
        "Hello, #{author}! The Guildmasters have been waiting",
        "#{author} would like to battle!"
      ]

      Embed.new(
        description: greetings.sample,
        color: event.author&.color&.combined,
        thumbnail: {
          url: img.url
        }
      )
    rescue StandardError => e
      error_embed(e.message)
    end
  end
end
