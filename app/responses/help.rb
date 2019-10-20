HELP_BLUE = "#4976ca"

def command_list_embed(commands, restriction = nil, title = nil)
  fields = []
  desc = "To learn more about any of the listed commands," +
    " use `pkmn-help [command]`"

  commands.each do |cmd|
    fields.push({name: "pkmn-#{cmd.name}", value: cmd.description})
  end

  desc = "#{restriction}\n#{desc}" if restriction

  Embed.new(
    title: title || "Commands",
    description: desc,
    color: HELP_BLUE,
    fields: fields
  )
end

def command_embed(command, restriction = nil)
  fields = usage_embed(command)
  title = "Usage"

  title += ": #{restriction}" if restriction

  embed = Embed.new(
    title: title,
    color: HELP_BLUE,
    footer: {
      text: "Questions? Ask a Guildmaster!"
    },
    fields: fields
  )

  embed.description = command.description if command.description
  embed
end

def usage_embed(command)
  fields = []

  command.options.map do |option, desc|
    fields.push({name: desc, value: "```pkmn-#{command.name} #{option}```"})
  end

  fields
end
