ERROR_RED = "#c42d2d"

def error_embed(message)
  Embed.new(
    title: "There was an Error",
    description: message,
    color: ERROR_RED,
    footer: {
      text: "For more help, feel free to ask a Moderator or Guildmaster"
    }
  )
end

def admin_error_embed(message)
  Embed.new(
    title: "Error",
    description: message,
    color: ERROR_RED
  )
end

def command_error_embed(message, command)
  Embed.new(
    title: "There was an Error",
    description: message,
    color: ERROR_RED,
    footer: {
      text: "For more help, feel free to ask a Moderator or Guildmaster"
    },
    fields: command_usage(command)
  )
end
