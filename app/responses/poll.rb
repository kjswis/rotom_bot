def new_poll_embed(event, options)
    fields = []
    optionsArray = options.split(",")
    name = event.author.nickname || event.author.name

    a = optionsArray.count

    for b in 1..a-1 do            
        fields.push(name: Emoji::LETTERS[b-1], value: optionsArray[b] + "\n" + CharAppResponses::INLINE_SPACE , inline:true)
    end

    chat_embed = Embed.new(
        title:  optionsArray[0],
        description: "Created by : #{name}",
        color: event.author.color.combined,
        fields: fields
    )

    msg = event.send_embed("", chat_embed)

    for b in 1..a-1 do            
        msg.react(Emoji::LETTERS[b-1])
    end
  end