HELP_BLUE = "#4976ca"

def all_commands_embed(commands)
  fields = []

  commands.each do |command|
    fields.push({name: "pkmn-#{command.name}", value: command.description})
  end

  Embed.new(
    title: "Commands",
    description: "To learn more about any of the listed commands, use `pkmn-help [command]`",
    color: HELP_BLUE,
    fields: fields
  )
end

def command_embed(command)
  fields = command_usage(command)

  Embed.new(
    title: "pkmn-#{command.name}",
    description: command.description,
    color: HELP_BLUE,
    fields: fields
  )
end

def command_usage(command)
  fields = []

  unless command.options.empty?
    usage = "```bash\n"
    command.options.map do |option, description|
      usage += "##{description}\npkmn-#{command.name} #{option}\n\n"
    end
    usage += "```"
  end

  fields.push({name: "Usage", value: usage}) if command.options
  fields
end
