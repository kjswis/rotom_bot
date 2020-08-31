UNKNOWN_USER_IMG = "https://i.imgur.com/oRJwgRa.png"
ADOPT_IMG = "https://i.imgur.com/2u0fNd2.png"

SUCCESS_GREEN = "#6bc037"
ERROR_RED = "#c42d2d"

def author_footer(embed, author, info=[])
  # Select the proper text and image for the author
  # .unshift places the argument at the beginning of an array
  img = case author
        when /Public/i
          info.unshift("Adopt Me!")
          ADOPT_IMG
        when nil
          info.unshift("Unknown User")
          UNKNOWN_USER_IMG
        else
          info.unshift("#{author.name}##{author.tag}")
          author.avatar_url
        end

  # Update the footer with the appropriate information
  embed.footer = {
    text: info.compact.join(" | "),
    icon_url: img
  }

  embed
end

def message_embed(title, desc, img = nil)
  embed = Embed.new(
    title: title,
    description: desc,
    color: SUCCESS_GREEN,
  )

  embed.thumbnail = { url: img } if img
  embed
end

def success_embed(message)
  Embed.new(
    title: "Hooray!",
    description: message,
    color: SUCCESS_GREEN,
    footer: {
      text: "High Five!"
    }
  )
end

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

def generic_error(message)
  Embed.new(
    title: "Error",
    description: message,
    color: ERROR_RED
  )
end
