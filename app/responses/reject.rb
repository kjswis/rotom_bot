MSG = "Please resubmit when you've addressed the issues!\n"
FTR = "If you have any questions, feel free to ask a Guildmaster"

def reject_app_embed(app, opts = nil)
  instr_check =
    "#{Emoji::CHECK} : Indicates you are ready to send the corresponding " +
    "messages to the user"
  instr_cross =
    "#{Emoji::CROSS} : Indicates you want to dismiss this message and " +
    "not send a message to the user"
  instr_crayon =
    "#{Emoji::CRAYON} : Indicates you want to edit the users form for " +
    "them, and resubmit on their behalf"

  fields = []

  #app.fields.each do |f|
    #fields.push({ name: f.name, value: f.value, inline: true })
  #end

  if opts
    fields.push({ name: "\u200b", value: "\u200b" })

    msgs =
      case opts
      when :character
        instructions = "#{instr_check}\n#{instr_cross}\n#{instr_crayon}"
        CharApp::REJECT_MESSAGES
      when :image
        instructions = "#{instr_check}\n#{instr_cross}"
        ImgApp::REJECT_MESSAGES
      else
        instructions = "#{instr_crayon}\n#{instr_cross}"
      end

    msgs.map do |emoji, message|
      fields.push({
        name: emoji,
        value: "#{message}\n#{CharApp::INLINE_SPACE}",
        inline: true
      })
    end

    fields.push({
      name: "Submitting",
      value: instructions
    })
  end

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

  embed.thumbnail = { url: app.image.url } if app.image
  embed.thumbnail = { url: app.thumbnail.url } if app.thumbnail

  embed
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

  embed.thumbnail = { url: app.thumbnail.url } if app.thumbnail
  embed
end

def self_edit_embed(app, form)
  Embed.new(
    title: "Don't forget to resubmit!",
    color: ERROR,
    description: "[Edit the Application](#{form}#{app.footer.text})"
  )
end

def char_reactive(form, edit_url)
  Embed.new(
    title: "Your reactivation request has been declined!",
    color: ERROR,
    description: "[Edit the Application](#{form}#{edit_url})"
  )
end
