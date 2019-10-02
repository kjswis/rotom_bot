def new_app_embed(event)
  name = event.author.nickname || event.author.name

  chat_embed = Embed.new(
    title: "New Application!",
    description: "Hi, #{name},\nI see you'd like to start a new character application!\nI'll send you instructions in a dm!",
    color: event.author.color.combined
  )

  embed = Embed.new(
    title: "Hi, #{name}",
    description: "If you have any questions, please feel free to ask a Guildmaster!",
    color: event.author.color.combined,
    fields: [
      { name: "Please start your application here:", value: APP_FORM },
      { name: "Your key is:", value: event.author.id }
    ]
  )

  event.send_embed("", chat_embed)
  embed
end

def edit_app_embed(event, edit_url, char_name)
  name = event.author.nickname || event.author.name

  chat_embed = Embed.new(
    title: "You want to edit #{char_name}?",
    description: "Good news, #{name}! I'll dm you a link",
    color: event.author.color.combined
  )

  embed = Embed.new(
    title: "You may edit #{char_name} here:",
    description: edit_url,
    color: event.author.color.combined
  )

  event.send_embed("", chat_embed)
  embed
end

def app_not_found_embed(event, char_name)
  name = event.author.nickname || event.author.name

  embed = Embed.new(
    title: "I'm sorry, #{name}",
    description: "I can't seem to find your character named, #{char_name}",
    color: "#a41e1f",
    fields: [
      { name: "Want to start a new application?", value: "You can start one with this command:\n```pkmn-app```"}
    ]
  )

  event.send_embed("", embed)
end
