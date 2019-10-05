def new_poll_embed(event, question, options)
    fields = []
    name = event.author.nickname || event.author.name

    options.map.with_index do |option, index|
      fields.push({ name: "#{Emoji::LETTERS[index]} #{option}", value: CharAppResponses::INLINE_SPACE, inline: true })
    end

    chat_embed = Embed.new(
        title:  question,
        description: "Created by : #{name}",
        fields: fields
    )

    chat_embed.color = event.author.color.combined

    poll = event.send_embed("", chat_embed)
    options.each.with_index do |_, index|
      poll.react(Emoji::LETTERS[index])
    end
  end
