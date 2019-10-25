def new_app_embed(user_name, color)
  desc = "Hi, #{user_name},\nI see you'd like to start a new character" +
    " application!\nI'll send you instructions in a dm!"
  Embed.new(
    title: "New Application!",
    description: desc,
    color: color
  )
end

def new_app_dm(user_name, color, code)
  Embed.new(
    title: "Hi, #{user_name}",
    description: "If you have any questions, feel free to ask a Guildmaster!",
    color: color,
    footer: {
      text: "If you cannot copy your key, press the #{Emoji::PHONE}"
    },
    fields: [
      { name: "Please start your application here:", value: Url::CHAR },
      { name: "Your key is:", value: code }
    ]
  )
end

def edit_app_embed(user_name, char_name, color)
  Embed.new(
    title: "You want to edit #{char_name}?",
    description: "Good news, #{user_name}! I'll dm you a link",
    color: color
  )
end

def edit_app_dm(char_name, edit_url, color)
  Embed.new(
    title: "You may edit #{char_name} here:",
    description: edit_url,
    color: color
  )
end

def app_not_found_embed(user_name, char_name)
  Embed.new(
    title: "I'm sorry, #{user_name}",
    description: "I can't seem to find your character named, #{char_name}",
    color: Color::ERROR,
    fields: [
      {
        name: "Want to start a new application?",
        value: "You can start one with this command:\n```pkmn-app```"
      }
    ]
  )
end
