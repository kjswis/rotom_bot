def character_embed(character, image, user, color)
  fields = []
  footer_text = "#{user.name}##{user.tag} | #{character.active}"
  footer_text += " | #{character.rating}" if character.rating

  fields.push(
    { name: 'Species', value: character.species, inline: true }
  )if character.species
  fields.push(
    { name: 'Type', value: character.types, inline: true }
  )if character.types
  fields.push(
    { name: 'Age', value: character.age, inline: true }
  )if character.age
  fields.push(
    { name: 'Weight', value: character.weight, inline: true }
  )if character.weight
  fields.push(
    { name: 'Height', value: character.height, inline: true }
  )if character.height
  fields.push(
    { name: 'Gender', value: character.gender, inline: true }
  )if character.gender
  fields.push(
    { name: 'Sexual Orientation', value: character.orientation, inline: true }
  )if character.orientation
  fields.push(
    { name: 'Relationship Status', value: character.relationship, inline: true }
  )if character.relationship
  fields.push(
    { name: 'Hometown', value: character.hometown, inline: true }
  )if character.hometown
  fields.push(
    { name: 'Location', value: character.location, inline: true }
  )if character.location
  fields.push(
    { name: 'Attacks', value: character.attacks }
  )if character.attacks
  fields.push(
    { name: 'Likes', value: character.likes }
  )if character.likes
  fields.push(
    { name: 'Dislikes', value: character.dislikes }
  )if character.dislikes
  fields.push(
    { name: 'Warnings', value: character.warnings }
  )if character.warnings
  fields.push(
    { name: 'Rumors', value: character.rumors }
  )if character.rumors
  fields.push(
    { name: 'Backstory', value: character.backstory }
  )if character.backstory
  fields.push(
    { name: 'Other', value: character.other }
  )if character.other
  fields.push(
    { name: 'DM Notes', value: character.dm_notes }
  )if character.dm_notes

  embed = Embed.new(
    footer: {
      icon_url: user.avatar_url,
      text: footer_text
    },
    title: character.name,
    color: color,
    fields: fields
  )

  embed.description = character.personality if character.personality
  embed.thumbnail = { url: image } if image

  embed
end

def char_image_embed(char, image, user, color)
  footer = "#{user.name}##{user.tag} | #{char.active}" +
    " | #{image.category}"

  Embed.new(
    footer: {
      icon_url: user.avatar_url,
      text: footer
    },
    title: "#{char.name} | #{image.keyword}",
    color: color,
    image: {
      url: image.url
    }
  )
end

def image_list_embed(char, images, user, color)
  desc = ""
  images.each do |img|
    desc += "[#{img.keyword}](#{img.url})\n" unless img.keyword == 'Default'
  end

  Embed.new(
    title: char.name,
    description: desc,
    color: color,
    footer: {
      icon_url: user.avatar_url,
      text: "#{user.name}##{user.tag} | #{char.active}"
    }
  )
end
