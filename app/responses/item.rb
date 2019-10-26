#frozen_string_literal: true

def item_embed(item)
  fields = []
  footer = item.category.join(" | ")
  footer += item.reusable ? " | Reusable" : " | Not Reusable"

  fields.push({ name: 'Effect', value: item.effect }) if item.effect

  embed = Embed.new(
    title: item.name,
    description: item.description,
    footer: {
      text: footer
    },
    fields: fields
  )

  embed.thumbnail = { url: item.url } if item.url
  embed
end

def item_list_embed(items)
  i = items.map(&:name) unless items.empty?
  desc = items.empty? ? "No Items Found" : i.join(", ")

  Embed.new(
    title: 'Items',
    description: desc
  )
end
