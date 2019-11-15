def status_list
  statuses = Status.all
  amounts = []
  no_amounts = []

  statuses.each do |s|
    if s.amount
      amounts.push(s.name)
    else
      no_amounts.push(s.name)
    end
  end

  fields = []
  fields.push(
    { name: 'Stackable Effects', value: amounts.join(", ")}
  )unless amounts.empty?

  fields.push(
    { name: 'Non-Stackable Effects', value: no_amounts.join(", ")}
  )unless no_amounts.empty?

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
