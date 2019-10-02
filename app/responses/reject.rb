def reject_char_embed(app)
  image_url = /\*\*URL to the Character\'s Appearance\*\*\:\s(.*)/.match(app)

  fields = []

  CharAppResponses::REJECT_MESSAGES.map do |emoji, message|
    fields.push({ name: emoji, value: "#{message}\n#{CharAppResponses::INLINE_SPACE}", inline: true })
  end

  fields.push({ name: "Submitting", value: "#{Emoji::CHECK} : Indicates you are ready to send the corresponding messages to the user\n#{Emoji::CROSS} : Indicates you want to dismiss this message and not send a message to the user\n#{Emoji::CRAYON} : Indicates you want to edit the users form for them, and resubmit on their behalf" })

  Embed.new(
    title: "**_APPLICATION REJECTED_**",
    description: "Please indicate what message to forward to the user!",
    color: "#a41e1f",
    thumbnail: {
      url: image_url[1]
    },
    fields: fields
  )
end
