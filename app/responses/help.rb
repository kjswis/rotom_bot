def all_commands(commands)
  fields = []

  commands.each do |command|
    fields.push({name: "pkmn-#{command.name}", value: command.description})
  end

  Embed.new(
    title: "Commands",
    description: "To learn more about any of the listed commands, use `pkmn-help [command]`",
    color: "#73FE49",
    fields: fields
  )
end

def command_usage(command)
  fields = []

  unless command.options.empty?
    usage = "```\n"
    command.options.each do |option|
      usage += "pkmn-#{command.name} #{option}\n"
    end
    usage += "```"
  end

  fields.push({name: "Usage", value: usage}) if command.options

  Embed.new(
    title: "pkmn-#{command.name}",
    description: command.description,
    color: "#73fe49",
    fields: fields
  )
end
