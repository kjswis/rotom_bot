UNKNOWN_USER_IMG = "https://i.imgur.com/oRJwgRa.png"

def character_embed(char:, img: nil, user: nil, color:, section: nil, event: nil)
  fields = []
  icon = nil

  user_name = case user
              when /Public/i
                'Adopt Me!'
              when /Server/i
                icon = event.server.icon_url if event
                'Server Owned'
              when nil
                icon = UNKNOWN_USER_IMG
                'Unknown User'
              else
                icon = user.avatar_url
                "#{user.name}##{user.tag}"
              end

  footer_text = "#{user_name} | #{char.active}"
  footer_text += " | #{char.rating}" if char.rating
  footer_text += " | #{img&.category} " if section == :image

  navigate = "React to Navigate"
  footer_text += " | #{navigate}" unless section.nil?

  status_effects = CharStatus.where(char_id: char.id)
  char_teams = CharTeam.where(char_id: char.id, active: true)

  embed = Embed.new(
    footer: {
      text: footer_text
    },
    title: char.name,
    color: color,
  )

  case section
  when :all, nil, :default
    embed.description = char.personality if char.personality
    fields = char_type(char, fields)
    fields = char_status(char, fields, status_effects)
    fields = char_bio(char, fields, char_teams)
    fields = char_rumors(char, fields)
  when :bio
    embed.description = char.personality if char.personality
    fields = char_bio(char, fields, char_teams)
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
    fields = char_inv(bags, fields, char.name)
  end


  embed.thumbnail = { url: img.url } if img && section != :image
  embed.fields = fields
  embed.footer.icon_url = icon

  embed
end

def char_bio(char, fields, char_teams)
  teams = []
  char_teams.each do |ct|
    teams.push(Team.find(ct.team_id).name)
  end

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
  fields.push(
    { name: 'Team', value: teams.join("\n") }
  )if !teams.empty?

  fields
end

def char_type(char, fields)
  sp = char.shiny ? "#{char.species} #{Emoji::STAR}" : char.species

  fields.push(
    { name: 'Species', value: sp, inline: true }
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
    if s.amount
      afs.push("#{se.amount}% #{s.effect.downcase}")
    else
      afs.push(s.effect.capitalize)
    end
  end

  fields.push(
    { name: "Current Afflictions", value: afs.join("\n") }
  )unless afs.empty?

  fields
end

def char_inv(bags, fields, name=nil)
  inv = []
  bags.each do |line|
    item = Item.find(line.item_id)
    inv_line = line.amount > 1 ? "#{item.name} [#{line.amount}]" : item.name
    inv.push(inv_line)
  end

  value = inv.join("\n") || "#{name} doesn't have any items"
  fields.push({ name: "Bags", value: value, inline: true })
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
  archived = []
  owned_npcs = []
  unowned_npcs = []

  list = {
    "Active Guild Members" => active,
    "Archived Guild Members" => archived,
    "NPCs" => owned_npcs,
    "Public NPCs" => unowned_npcs
  }

  chars.each do |char|
    case char.active
    when 'Active'
      active.push char.name
    when 'Archived'
      archived.push char.name
    when 'NPC'
      owned_npcs.push char.name if char.user_id != 'Public'
      unowned_npcs.push char.name if char.user_id == 'Public'
    end
  end

  list.each do |name, array|
    unless array.empty?
      array = array.sort

      array.each_slice(100).each_with_index do |a, i|
        fields.push({
          name: "#{name} [#{i > 0 ? 'cont' : array.count}]",
          value: a.join(", ")
        })
      end
    end
  end

  embed = Embed.new(
    title: "Registered Pokemon [#{chars.count}]",
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
  archived = []
  npcs = []
  user_name = user&.nickname || user&.name

  chars.each do |char|
    case char.active
    when 'Active'
      active.push char
    when 'Archived'
      archived.push char.name
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

  unless archived.empty?
    fields.push({
      name: "#{user_name}'s Archived Characters",
      value: archived.join(", ")
    })
  end

  unless npcs.empty?
    fields.push({ name: "#{user_name}'s NPCs", value: npcs.join(", ") })
  end

  if user
    allowed = User.find_by(id: user&.id).level / 10 + 1
    allowed =
      user.roles.map(&:name).include?('Nitro Booster') ? allowed + 1 : allowed
  else
    allowed = '???'
  end

  embed = Embed.new(
    title: "#{user_name}'s Characters [#{active.count}/#{allowed}]",
    description: "Click on the corresponding reaction to view the character",
    fields: fields
  )

  embed.color = user.color.combined if user&.color
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

def nsfw_char_embed(char:, user: nil, color:, event: nil)
  icon = nil

  user_name = case user
              when /Public/i
                'Adopt Me!'
              when /Server/i
                icon = event.server.icon_url if event
                'Server Owned'
              when nil
                icon = UNKNOWN_USER_IMG
                'Unknown User'
              else
                icon = user.avatar_url
                "#{user.name}##{user.tag}"
              end

  footer_text = "#{user_name} | #{char.active}"
  footer_text += " | #{char.rating}" if char.rating

  embed = Embed.new(
    footer: {
      icon_url: icon,
      text: footer_text
    },
    title: char.name,
    color: color,
    fields: [
      { name: 'Wrong Channel!', value: "The requested information contains NSFW content" }
    ]
  )

  embed
end
