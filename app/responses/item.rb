#frozen_string_literal: true

def item_embed(item)
  fields = []
  footer = item.category.join(" | ")
  footer += " | Reusable" if item.reusable

  fields.push({ name: 'Status', value: item.status }) if item.status
  fields.push({ name: 'RP Reply', value: item.rp_reply }) if item.rp_reply

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
