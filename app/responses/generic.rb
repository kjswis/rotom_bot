def new_generic_embed(event, title, text)
    name = event.author.nickname || event.author.name

    chat_embed = Embed.new(
        title:  title,
        description: text
    )

    chat_embed.color = event.author.color.combined

    raffle = event.send_embed("", chat_embed)
  end
