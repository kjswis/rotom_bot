MSG = "Please resubmit when you've addressed the issues!\n"
FTR = "If you have any questions, feel free to ask a Guildmaster"

def reject_char_embed(app)
  fields = []

  app.fields.each do |f|
    fields.push({ name: f.name, value: f.value, inline: true })
  end

  fields.push({ name: "\u200b", value: "\u200b" })

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
    title: app.title,
    description: app.description,
    author: {
      name: app.author.name.gsub('Application', 'Rejection'),
      icon_url: app.author.icon_url
    },
    color: ERROR,
    footer: {
      text: app.footer.text
    },
    fields: fields
  )

  embed.thumbnail.url = app.thumbnail.url if app.thumbnail

  embed
end

def reject_img_embed(app)
  fields = []

  app.fields.each do |f|
    fields.push({ name: f.name, value: f.value, inline: true })
  end

  fields.push({ name: "\u200b", value: "\u200b" })

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

  Embed.new(
    title: app.title,
    description: app.description,
    author: {
      name: app.author.name.gsub('Application', 'Rejection'),
      icon_url: app.author.icon_url
    },
    thumbnail: {
      url: app.image.url
    },
    color: ERROR,
    footer: {
      text: app.footer.text
    },
    fields: fields
  )
end

def user_char_app(event)
  reactions = event.message.reactions
  app = event.message.embeds.first

  description = ""

  Emoji::CHAR_APP.each do |reaction|
    if reactions[reaction].count > 1
      m = CharApp::REJECT_MESSAGES[reaction].gsub("\n", " ")
      description += "\n#{m}"
    end
  end

  embed = Embed.new(
    title: "**Your application has been rejected!!**",
    color: ERROR,
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
        value: "[Edit Your Application](#{Url::CHARACTER}#{app.footer.text})"
      }
    ]
  )

  embed
end

def user_img_app(event)
  reactions = event.message.reactions
  app = event.message.embeds.first

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
    color: ERROR,
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

  embed.thumbnail.url = app.thumbnail.url if app.thumbnail
  embed
end

def self_edit_embed(app)
  Embed.new(
    title: "Don't forget to resubmit!",
    color: ERROR,
    description: "[Edit the Application](#{Url::CHARACTER}#{app.footer.text})"
  )
end
