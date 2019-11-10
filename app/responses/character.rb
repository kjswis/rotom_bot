def character_embed(char:, img: nil, user: nil, color:, section: nil)
  fields = []
  user_name = case user
              when String
                user.capitalize
              when nil
                'Unknown User'
              else
                "#{user.name}##{user.tag}"
              end

  footer_text = "#{user_name} | #{char.active}"
  footer_text += " | #{char.rating}" if char.rating
  footer_text += " | #{img.category} " if section == :image

  navigate = "React to Navigate"
  footer_text += " | #{navigate}" unless section.nil?

  status_effects = CharStatus.where(char_id: char.id)

  embed = Embed.new(
    footer: {
      text: footer_text
    },
    title: char.name,
    color: color,
  )

  case section
  when :all, nil
    embed.description = char.personality if char.personality
    fields = char_type(char, fields)
    fields = char_status(char, fields, status_effects)
    fields = char_bio(char, fields)
    fields = char_rumors(char, fields)
  when :default
    embed.description = navigate
    fields = char_sections(fields)
  when :bio
    embed.description = char.personality if char.personality
    fields = char_bio(char, fields)
  when :type
    fields = char_type(char, fields)
  when :status
    fields = char_status(char, fields, status_effects)
  when :rumors
    fields = char_rumors(char, fields)
  when :image
    if img
      embed.title =
        "#{char.name} | #{img.keyword}" unless img.keyword == 'Default'
      embed.image = { url: img.url }
    else
      embed.description = "No character images found!"
    end
  when :bags
    bags = Inventory.where(char_id: char.id)
    fields = char_inv(bags, fields)
  end


  embed.thumbnail = { url: img.url } if img && section != :image
  embed.fields = fields
  embed.footer.icon_url = user.avatar_url if user && user != 'Public'

  embed
end

def char_bio(char, fields)
  fields.push(
    { name: 'Hometown', value: char.hometown, inline: true }
  )if char.hometown
  fields.push(
    { name: 'Location', value: char.location, inline: true }
  )if char.location
  fields.push(
    { name: 'Likes', value: char.likes }
  )if char.likes
  fields.push(
    { name: 'Dislikes', value: char.dislikes }
  )if char.dislikes
  fields.push(
    { name: 'Backstory', value: char.backstory }
  )if char.backstory
  fields.push(
    { name: 'Other', value: char.other }
  )if char.other
  fields.push(
    { name: 'DM Notes', value: char.dm_notes }
  )if char.dm_notes

  fields
end

def char_type(char, fields)
  fields.push(
    { name: 'Species', value: char.species, inline: true }
  )if char.species
  fields.push(
    { name: 'Type', value: char.types, inline: true }
  )if char.types

  if char.attacks
    attacks = char.attacks
    attacks = attacks.gsub(/\s?\|\s?/, "\n")

    fields.push({ name: 'Attacks', value: attacks })
  end

  fields
end

def char_rumors(char, fields)
  fields.push(
    { name: 'Warnings', value: char.warnings }
  )if char.warnings

  if char.rumors
    rumors = char.rumors.split(/\s?\|\s?/)
    rumors = rumors.shuffle
    rumors = rumors.join("\n")

    fields.push({ name: 'Rumors', value: rumors })
  end

  fields
end

def char_status(char, fields, status_effects=nil)
  fields.push(
    { name: 'Age', value: char.age, inline: true }
  )if char.age
  fields.push(
    { name: 'Gender', value: char.gender, inline: true }
  )if char.gender
  fields.push(
    { name: 'Weight', value: char.weight, inline: true }
  )if char.weight
  fields.push(
    { name: 'Height', value: char.height, inline: true }
  )if char.height
  fields.push(
    { name: 'Sexual Orientation', value: char.orientation, inline: true }
  )if char.orientation
  fields.push(
    { name: 'Relationship Status', value: char.relationship, inline: true }
  )if char.relationship

  afs = []
  status_effects.each do |se|
    s = Status.find(se.status_id)
    afs.push("#{se.amount}% #{s.effect.downcase}")
  end

  fields.push(
    { name: "Current Afflictions", value: afs.join("\n") }
  )unless afs.empty?

  fields
end

def char_inv(bags, fields)
  inv = []
  bags.each do |line|
    item = Item.find(line.item_id)
    inv_line = line.amount > 1 ? "#{item.name} [#{line.amount}]" : item.name
    inv.push(inv_line)
  end

  fields.push({ name: "Bags", value: inv.join("\n"), inline: true })
end

def char_sections(fields)
  CharCarousel::REACTIONS.map do |emoji, message|
    fields.push({
      name: emoji,
      value: message,
      inline: true
    })
  end

  fields
end

def char_list_embed(chars, user = nil)
  fields = []
  active = []
  inactive= []
  npcs = []

  chars.each do |char|
    case char.active
    when 'Active'
      active.push char.name
    when 'Inactive'
      inactive.push char.name
    when 'NPC'
      npcs.push char.name
    end
  end

  fields.push({
    name: 'Active Characters',
    value: active.join(", ")
  })if active.length > 0

  fields.push({
    name: 'Inactive Characters',
    value: inactive.join(", ")
  })if inactive.length > 0

  fields.push({
    name: 'NPCs',
    value: npcs.join(", ")
  })if npcs.length > 0

  embed = Embed.new(
    title: 'Registered Characters',
    fields: fields
  )

  if user
    user_name = user.nickname || user.name

    embed.color = user.color.combined
    embed.title = "#{user_name}'s Characters"
  end

  embed
end

def user_char_embed(chars, user)
  fields = []
  active = []
  inactive = []
  npcs = []
  user_name = user.nickname || user.name

  chars.each do |char|
    case char.active
    when 'Active'
      active.push char
    when 'Inactive'
      inactive.push char.name
    when 'NPC'
      npcs.push char.name
    end
  end

  active.each.with_index do |char, i|
    fields.push({
      name: "#{i+1} #{char.name}",
      value: "#{char.species} -- #{char.types}"
    })
  end

  unless inactive.empty?
    fields.push({
      name: "#{user_name}'s Inactive Characters",
      value: inactive.join(", ")
    })
  end

  unless npcs.empty?
    fields.push({ name: "#{user_name}'s NPCs", value: npcs.join(", ") })
  end

  embed = Embed.new(
    title: "#{user_name}'s Characters",
    description: "Click on the corresponding reaction to view the character",
    fields: fields
  )

  embed.color = user.color.combined if user.color
  embed
end

def dup_char_embed(chars, name)
  fields = []

  chars.each.with_index do |char, i|
    fields.push({
      name: "#{Emoji::NUMBERS[i]}: #{char.species}",
      value: "Created by <@#{char.user_id}>"
    })
  end

  Embed.new(
    title: "Which #{name}?",
    description: "Click on the corresponding reaction to pick",
    fields: fields
  )
end

def char_image_embed(char, image, user, color)
  user_name = case user
              when String
                user.capitalize
              when nil
                'Unknown User'
              else
                "#{user.name}##{user.tag}"
              end

  footer_text = "#{user_name} | #{char.active}"
  footer_text += " | #{char.rating}" if char.rating
  footer_text += " | #{image.category}"

  Embed.new(
    footer: {
      icon_url: user&.avatar_url,
      text: footer_text
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
