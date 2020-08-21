HELP_BLUE = "#4976ca"

def command_list_embed(commands, restriction = nil)
  fields = []
  desc = "To learn more about any of the listed commands," +
    " use `pkmn-help [command]`"

  commands.each do |cmd|
    fields.push({name: "pkmn-#{cmd.name}", value: cmd.cmd.description})
  end

  case restriction
  when :pm
    title = "PM Commands"
    desc = "Can only be used in a PM with <@639191920786276378> \n" +
      "To learn more about any of the listed commands, use `pkmn-help [command]`"

  else
  end

  Embed.new(
    title: title || "Commands",
    description: desc,
    color: HELP_BLUE,
    fields: fields
  )
end

def command_help(command, event)
  embed = Embed.new(
    title: command.to_s.gsub('Command', ' Command'),
    description: command.cmd.description,
    color: HELP_BLUE,
    footer: { text: "For more help, ask a Guild Master!" }
  )

  # Apply options, if there are any
  fields = command_usage(command, event) unless command.cmd.options.empty?
  # If in the admin channel, show additional admin options
  fields = admin_options(command, fields) if event.channel.id == ENV['ADMIN_CH'].to_i

  # Apply fields and return
  embed.fields = fields
  embed
end

def command_usage(command, event)
  # save the options, to shorten the logic later
  opts = command.cmd.options
  example = command.example_command(event)
  fields = []

  # Add navigation information, if there is any
  fields.push({
    name: "Reaction Navigation",
    value: opts[:nav].map{ |k,v| "#{v[0]} - `#{k}` - #{v[1]}" }.join("\n")
  }) if opts[:nav]

  # Save the command with its options, and the option instructions
  structure = "```pkmn-#{command.name} #{opts[:usage].map{ |k,v| k }.join(' | ')}```"
  instructions = opts[:usage].map{ |k,v| "- `#{k}` -- #{v}" }.join("\n")

  # Add usage information
  fields.push({
    name: "Command Usage",
    value: "#{structure}\n#{instructions}"
  })

  # Add an example command
  fields.push({
    name: "Example",
    value: "```pkmn-#{command.name} #{example.join(' | ')}```"
  })
end

def admin_options(command, fields)
  # Find the admin options, and return if there are none
  r_opts = command.admin_opts
  return fields unless r_opts

  # Save the command with its options, and the option instructions
  structure = "```pkmn-#{command.name} #{r_opts[:usage].map{ |k,v| k }.join(' | ')}```"
  instructions = r_opts[:usage].map{ |k,v| "- `#{k}` -- #{v}" }.join("\n")

  # Add usage information
  fields.push({
    name: "Administrator Options",
    value: "#{structure}\n#{instructions}"
  })

  fields
end

def command_error(title, command, event=nil)
  embed = Embed.new(
    title: title,
    description: command.cmd.description,
    color: ERROR_RED,
    footer: { text: "For more help, ask a Guild Master!" }
  )

  # Apply options, if there are any
  fields = command_usage(command, event) unless command.cmd.options.empty?
  # If in the admin channel, show additional admin options
  fields = admin_options(command, fields) if event&.channel&.id == ENV['ADMIN_CH'].to_i

  # Apply fields and return
  embed.fields = fields
  embed
end
