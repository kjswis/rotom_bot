MSG = "Please resubmit when you've addressed the issues!\n"
FTR = "If you have any questions, feel free to ask a Guildmaster"

def reject_app(app, opts)
  embed = Embed.new(
    title: app.title,
    description: app.description,
    color: ERROR,
    author: {
      name: app.author.name.gsub('Application', 'Rejection'),
      icon_url: app.author.icon_url
    },
    footer: { text: app.footer.text }
  )

  fields = case opts
           when :character
             reject_fields(CharApp::REJECT_MESSAGES)
           when :image
             reject_fields(ImgApp::REJECT_MESSAGES)
           when :landmark
             reject_fields(LmApp::REJECT_MESSAGES)
           when :reactivation
             # Find Character
             character = Character.find(app.footer.text.match(/\|\s(\d+)$/)[1])

             # Set embed up correctly
             embed.title = character.name
             embed.description = "<@#{character.user_id}>"
             embed.footer = { text: character.edit_url }
             embed.author = { name: 'Character Rejection' }

             reject_fields(CharApp::REJECT_MESSAGES)
           end

  # Add one last field and update embed
  fields.push({ name: Emoji::CHECK, value: "Indicates you are finished" })
  embed.fields = fields
  embed
end

def reject_fields(message_hash)
  message_hash.map{ |e,m| { name: e, value: m, inline: true } }
end

def rejected_app(event, opts)
  # Save the app and the reactions
  app = event.message.embeds.first
  reactions = event.message.reactions

  # Fill out the selected messages in accordance with the form
  fields =
    case opts
    when :character
      [{
        name: "Messages from the admin:",
        value: selected_messages(reactions, CharApp::REJECT_MESSAGES).
        join("\n") || 'No messages given'
      },{
        name: MSG,
        value: "[Edit Your Application](#{URL::CHARACTER}" +
        "#{app.footer.text})"
      }]
    when :image
      [{
        name: "Messages from the admin:",
        value: selected_messages(reactions, ImgApp::REJECT_MESSAGES).
        join("\n") || 'No messages given'
      }]
    when :landmark
      [{
        name: "Messages from the admin:",
        value: selected_messages(reactions, LmApp::REJECT_MESSAGES).
        join("\n") || 'No messages given'
      },{
        name: MSG,
        value: "[Edit Your Application](#{URL::LANDMARK}" +
        "#{app.footer.text})"
      }]
    end

  # Populate embed and return
  Embed.new(
    title: "Your application has been rejected!",
    description: app.title,
    color: ERROR,
    footer: { text: FTR },
    fields: fields
  )
end

def selected_messages(reactions, hash)
  messages = []
  hash.each do |emoji, message|
    messages.push(message) if reactions[emoji]&.count.to_i > 1
  end
  messages
end

def self_edit_embed(edit_url, form)
  Embed.new(
    title: "Don't forget to resubmit!",
    color: ERROR,
    description: "[Edit the Application](#{form}#{edit_url})"
  )
end
