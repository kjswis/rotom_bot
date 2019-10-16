def reject_char_embed(app)
  image_url = /\*\*URL to the Character\'s Appearance\*\*\:\s(.*)/.match(app)

  fields = []

  CharAppResponses::REJECT_MESSAGES.map do |emoji, message|
    fields.push({ name: emoji, value: "#{message}\n#{CharAppResponses::INLINE_SPACE}", inline: true })
  end

  fields.push({ name: "Submitting", value: "#{Emoji::CHECK} : Indicates you are ready to send the corresponding messages to the user\n#{Emoji::CROSS} : Indicates you want to dismiss this message and not send a message to the user\n#{Emoji::CRAYON} : Indicates you want to edit the users form for them, and resubmit on their behalf" })

  embed = Embed.new(
    title: "**_APPLICATION REJECTED_**",
    description: "Please indicate what message to forward to the user!",
    color: Color::ERROR,
    fields: fields
  )

  embed.thumbnail = { url: image_url[1] } if image_url
  embed
end

def message_user_embed(event)
  reactions = event.message.reactions
  content = event.message.content

  edit_url = Regex::EDIT_URL.match(content)
  description = ""

  Emoji::APP_SECTIONS.each do |reaction|
    if reactions[reaction].count > 1
      m = CharAppResponses::REJECT_MESSAGES[reaction].gsub("\n", " ")
      description += "\n#{m}"
    end
  end

  embed = Embed.new(
    title: "**Your application has been rejected!!**",
    color: Color::ERROR,
    fields: [
      { name: "Listed reasons for rejection:", value: description },
      { name: "You can edit your application and resubmit here:", value: "#{Url::CHARACTER}#{edit_url[1]}" }
    ]
  )

  embed
end

def self_edit_embed(content)
  edit_url = Regex::EDIT_URL.match(content)

  Embed.new(
    title: "Please edit the user's application and resubmit!",
    color: Color::ERROR,
    description: "#{Url::CHARACTER}#{edit_url[1]}"
  )
end
