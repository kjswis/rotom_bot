ERROR_RED = "#c42d2d"

def error_embed(title, message = nil)
  embed = Embed.new(
    title: title,
    color: ERROR_RED,
    footer: {
      text: "For more help, feel free to ask a Moderator or Guildmaster"
    }
  )

  embed.description = message if message
  embed
end

def admin_error_embed(message)
  Embed.new(
    title: "Error",
    description: message,
    color: ERROR_RED
  )
end

def command_error_embed(title, command)
  Embed.new(
    title: title,
    color: ERROR_RED,
    footer: {
      text: "For more help, feel free to ask a Moderator or Guildmaster"
    },
    fields: command_usage(command)
  )
end
