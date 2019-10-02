def character_embed(character, image, member)
  fields = []
  user = "#{member.name}##{member.tag}"
  footer_text = "Created by #{user} | #{character.active}"
  footer_text += " | #{character.rating}" if character.rating

  fields.push({name: 'Species', value: character.species, inline: true}) if character.species
  fields.push({name: 'Type', value: character.types, inline: true}) if character.types
  fields.push({name: 'Age', value: character.age, inline: true}) if character.age
  fields.push({name: 'Weight', value: character.weight, inline: true}) if character.weight
  fields.push({name: 'Height', value: character.height, inline: true}) if character.height
  fields.push({name: 'Gender', value: character.gender, inline: true}) if character.gender
  fields.push({name: 'Sexual Orientation', value: character.orientation, inline: true}) if character.orientation
  fields.push({name: 'Relationship Status', value: character.relationship, inline: true}) if character.relationship
  fields.push({name: 'Hometown', value: character.hometown, inline: true}) if character.hometown
  fields.push({name: 'Location', value: character.location, inline: true}) if character.location
  fields.push({name: 'Attacks', value: character.attacks}) if character.attacks
  fields.push({name: 'Likes', value: character.likes}) if character.likes
  fields.push({name: 'Dislikes', value: character.dislikes}) if character.dislikes
  fields.push({name: 'Warnings', value: character.warnings}) if character.warnings
  fields.push({name: 'Rumors', value: character.rumors}) if character.rumors
  fields.push({name: 'Backstory', value: character.backstory}) if character.backstory
  fields.push({name: 'Other', value: character.other}) if character.other
  fields.push({name: 'DM Notes', value: character.dm_notes}) if character.dm_notes

  embed = Embed.new(
    footer: {
      text: footer_text
    },
    title: character.name,
    fields: fields
  )

  embed.description = character.personality if character.personality
  embed.thumbnail = { url: image } if image
  embed.color = member.color.combined if member.color.combined

  embed
end
