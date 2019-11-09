SUCCESS_GREEN = "#6bc037"

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

def message_embed(title, desc, img = nil)
  img = ImageUrl.find_by(name: 'happy').url unless img

  Embed.new(
    title: title,
    description: desc,
    color: SUCCESS_GREEN,
    thumbnail: {
      url: img
    }
  )
end
