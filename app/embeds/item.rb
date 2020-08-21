def item_embed(item, event)
  # Find the author, if they're a member, or in DMs use the event's author
  member = item.user_id.match(/public/i) ? 'Public' :
    event.server.member(item.user_id)
  fields = []

  embed = Embed.new(
    title: item.name,
    description: item.description,
  )

  embed.thumbnail = { url: item.url } if item.url
  author_footer(
    embed,
    member,
    [item.category.join(", "), item.reusable ? 'Reusable' : 'Not Resuable']
  )

  fields.push({ name: 'Effect', value: item.effect }) if item.effect
  embed.fields = fields
  embed
end

def item_list
  Embed.new(
    title: 'Items',
    description: Item.all.map(&:name).join(", ")
  )
end
