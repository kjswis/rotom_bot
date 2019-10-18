def new_generic_embed(event, title, text)
  chat_embed = Embed.new(
    title:  title,
    description: text
  )

  chat_embed.color = event.author.color.combined
  chat_embed
end
