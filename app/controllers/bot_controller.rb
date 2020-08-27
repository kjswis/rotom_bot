class BotController
  def self.reply(bot, event, response)
    case response
    when Array
      response.each do |r|
        r.call(event, bot) if r.is_a? BotResponse
      end
    when BotResponse
      response.call(event, bot)
    when Embed
      event.send_embed("", response)
    when String
      event.respond(response)
    end
  end

  def self.application_react(event)
    Emoji::APPLICATION.each do |e|
      event.message.react(e)
    end
  end

  def self.unauthorized_char_app(bot, event)
    # Save app
    app = event.message.embeds.first

    # Save user_id and edit_url
    user_id = app.description.match(UID)[1]
    edit_url = app.footer.text

    # Find the discord member
    member = event.server.member(user_id)

    embed = Embed.new(
      title: "You have too many characters!",
      description: "Please deactivate and try again " +
      "[here](#{Url::CHARACTER}#{edit_url})"
    )

    response = [
      BotResponse.new(destination: member.dm, embed: embed),
      BotResponse.new(embed: embed)
    ]

    event.message.delete

    reply(bot, event, response)
  end
end
