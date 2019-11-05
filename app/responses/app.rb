def new_app_embed(user_name, color = nil)
  desc = "Hi, #{user_name},\nI see you'd like to start a new character" +
    " application!\nI'll send you instructions in a dm!"
  embed = Embed.new(
    title: "New Appliction!",
    description: desc
  )

  embed.color = color if color
  embed
end

def new_app_dm(user_name, code, color = nil)
  embed = Embed.new(
    title: "Hi, #{user_name}",
    description: "If you have any questions, feel free to ask a Guildmaster!",
    footer: {
      text: "If you cannot copy your key, press the #{Emoji::PHONE}"
    },
    fields: [
      { name: "Please start your application here:", value: Url::CHAR },
      { name: "Your key is:", value: code }
    ]
  )

  embed.color = color if color
  embed
end

def edit_app_embed(user_name, char_name, color = nil)
  embed = Embed.new(
    title: "You want to edit #{char_name}?",
    description: "Good news, #{user_name}! I'll dm you a link"
  )

  embed.color = color if color
  embed
end

def edit_app_dm(char_name, edit_url, color = nil)
  embed = Embed.new(
    title: "You may edit #{char_name} here:",
    description: edit_url
  )

  embed.color = color if color
  embed
end

def app_not_found_embed(user_name, char_name)
  Embed.new(
    title: "I'm sorry, #{user_name}",
    description: "I can't seem to find your character named, #{char_name}",
    color: ERROR,
    fields: [
      {
        name: "Want to start a new application?",
        value: "You can start one with this command:\n```pkmn-app```"
      }
    ]
  )
end
