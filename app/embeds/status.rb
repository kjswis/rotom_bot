def status_list
  # Create Status lists
  # Split Statuses by stackable, and non-stackable, saving only their names
  stackable, non_stackable = Status.all.partition{ |s| s.amount }

  # Push the categorized Statuses into embed fields
  fields = []
  fields.push(
    { name: 'Stackable Effects', value: stackable.map(&:name).join(", ")}
  ) unless stackable.empty?

  fields.push(
    { name: 'Non-Stackable Effects', value: non_stackable.map(&:name).join(", ")}
  ) unless non_stackable.empty?

  # Create Embed
  Embed.new(
    title: 'Statuses',
    fields: fields
  )
end

def status_details(status)
  Embed.new(
    title: status.name,
    description: "#{status.effect.capitalize}\n(Stacks: #{status.amount})"
  )
end
