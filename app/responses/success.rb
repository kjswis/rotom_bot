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
