MSG = "Please resubmit when you've addressed the issues!\n"
FTR = "If you have any questions, feel free to ask a Guildmaster"

def reject_char_embed(app)
  image_url = /\*\*URL to the Character\'s Appearance\*\*\:\s(.*)/.match(app)

  fields = []

  CharApp::REJECT_MESSAGES.map do |emoji, message|
    fields.push({
      name: emoji,
      value: "#{message}\n#{CharApp::INLINE_SPACE}",
      inline: true
    })
  end

  instructions =
    "#{Emoji::CHECK} : Indicates you are ready to send the corresponding " +
    "messages to the user\n" +
    "#{Emoji::CROSS} : Indicates you want to dismiss this message and " +
    "not send a message to the user\n" +
    "#{Emoji::CRAYON} : Indicates you want to edit the users form for them," +
    " and resubmit on their behalf"

  fields.push({
    name: "Submitting",
    value: instructions
  })

  embed = Embed.new(
    title: "**_APPLICATION REJECTED_**",
    description: "Please indicate what message to forward to the user!",
    color: Color::ERROR,
    fields: fields
  )

  embed.thumbnail = { url: image_url[1] } if image_url
  embed
end

def reject_img_embed(app)
  img_url = /\*\*URL\*\*:\s(.*)/.match(app)
  fields = []

  ImgApp::REJECT_MESSAGES.map do |emoji, message|
    fields.push({
      name: emoji,
      value: "#{message}\n#{ImgApp::INLINE_SPACE}",
      inline: true
    })
  end

  instructions =
    "#{Emoji::CHECK} : Indicates you are ready to send the corresponding " +
    "messages to the user\n" +
    "#{Emoji::CROSS} : Indicates you want to dismiss this message and " +
    "not send a message to the user\n"

  fields.push({
    name: "Submitting",
    value: instructions
  })

  embed = Embed.new(
    title: "**_APPLICATION REJECTED_**",
    description: "Please indicate what message to forward to the user!",
    color: Color::ERROR,
    fields: fields
  )

  embed.thumbnail = { url: img_url[1] } if img_url
  embed
end

def user_char_app(event)
  reactions = event.message.reactions
  content = event.message.content

  edit_url = Regex::EDIT_URL.match(content)
  description = ""

  Emoji::CHAR_APP.each do |reaction|
    if reactions[reaction].count > 1
      m = CharApp::REJECT_MESSAGES[reaction].gsub("\n", " ")
      description += "\n#{m}"
    end
  end

  embed = Embed.new(
    title: "**Your application has been rejected!!**",
    color: Color::ERROR,
    footer: {
      text: FTR
    },
    fields: [
      {
        name: "Listed reasons for rejection:",
        value: description
      },
      {
        name: MSG,
        value: "[Edit Your Application](#{Url::CHARACTER}#{edit_url[1]})"
      }
    ]
  )

  embed
end

def user_img_app(event)
  reactions = event.message.reactions
  content = event.message.content

  img_url = /\*\*URL\*\*:\s(.*)/.match(content)
  description = ""

  Emoji::IMG_APP.each do |reaction|
    if reactions[reaction].count > 1
      m = ImgApp::REJECT_MESSAGES[reaction].gsub("\n", " ")
      description += "\n#{m}"
    end
  end

  description += "\n\n#{MSG}"

  embed = Embed.new(
    title: "**Your application has been rejected!!**",
    color: Color::ERROR,
    thumbnail: {
      url: img_url[1]
    },
    footer: {
      text: FTR
    },
    fields: [
      {
        name: "Listed reasons for rejection:",
        value: description
      }
    ]
  )

  embed
end

def self_edit_embed(content)
  edit_url = Regex::EDIT_URL.match(content)

  Embed.new(
    title: "Don't forget to resubmit!",
    color: Color::ERROR,
    description: "[Edit the Application](#{Url::CHARACTER}#{edit_url[1]})"
  )
end
