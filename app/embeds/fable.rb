def fable_embed(fable, event)
  # Find the author, if they're a member
  author = event.server.member(fable.user_id)

  embed = Embed.new(
    title: fable.title,
    description: fable.story,
  )

  embed.image = { url: fable.url } if fable.url
  author_footer(embed, author, [fable.id])

  embed
end

def fable_list(fables)
  Embed.new(
    title: 'Related Fables',
    description: fables.map(&:title).join("\n")
  )
end
