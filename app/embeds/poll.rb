def new_poll(event, question, choices)
  fields = []

  choices.each.with_index do |c, i|
    fields.push({
      name: "#{Emoji::LETTERS[i]} #{c}",
      value: CharApp::INLINE_SPACE,
      inline: true
    })
  end

  embed = Embed.new(
    title:  question,
    author: {
      name: event.author.nickname || event.author.name,
      icon_url: event.author.avatar_url
    },
    fields: fields
  )

  embed.color = event.author.color.combined if event.author.color
  embed
end
