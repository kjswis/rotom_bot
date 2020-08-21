def new_app_request(user, app_type)
  embed = Embed.new(
    title: "New Appliction!",
    description: "Hi, #{user.nickname || user.name},\nI see you'd like to " +
      "start a new #{app_type.to_s} application!\nI'll DM you instructions!"
  )

  embed.color = user.color.combined if user.color
  embed
end

def new_app_form(user, app_type)
  url = case app_type
        when :character
          Url::CHAR
        when :landmark
          Url::LM
        end

  embed = Embed.new(
    title: "Hi, #{user.nickname || user.name}",
    description: "If you have any questions, feel free to ask a Guildmaster!",
    footer: {
      text: "If you cannot copy your key, press the #{Emoji::PHONE}"
    },
    fields: [
      { name: "Please start your application here:", value: url },
      { name: "Your key is:", value: user.id }
    ]
  )

  embed.color = user.color.combined if user.color
  embed
end

def edit_app_request(user, name)
  embed = Embed.new(
    title: "You want to edit #{name}?",
    description: "Good news, #{user.nickname || user.name}! I'll dm you a link"
  )

  embed.color = user.color.combined if user.color
  embed
end

def edit_app_form(user, model)
  edit_url = case model
             when Character
               "#{Url::CHARACTER}#{model.edit_url}"
             when Landmark
               "#{Url::LANDMARK}#{model.edit_url}"
             end
  embed = Embed.new(
    title: "You may edit #{model.name} here:",
    description: edit_url
  )

  embed.color = user.color.combined if user.color
  embed
end
