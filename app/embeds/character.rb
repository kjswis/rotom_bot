def character_embed(character:, event:, section: nil, image: nil, journal: nil)
  # Find the author, if they're a member, or in DMs use the event's author
  if event.server
    member = character.user_id.match(/public/i) ? 'Public' :
      event.server.member(character.user_id)
  else
    member = event.author
  end
  fields = []

  embed = Embed.new(
    title: character.name,
    color: character.type_color
  )

  # Save image, if there is one, and footer info
  default_img = CharImage.where(char_id: character.id).find_by(keyword: 'Default')
  footer_info = [character.active, character.rating]

  embed.thumbnail = { url: default_img.url } if default_img

  # Fill out the fields based on the section
  case section
  when /all/i, /default/i, nil
    embed.description = character.personality if character.personality
    fields = char_alias(character, fields)
    fields = char_type(character, fields)
    fields = char_status(character, fields)
    fields = char_bio(character, fields)
    fields = char_rumors(character, fields)
    fields = char_dm_notes(character, fields, event)
  when /bio/i
    embed.description = character.personality if character.personality
    fields = char_alias(character, fields)
    fields = char_bio(character, fields)
    fields = char_dm_notes(character, fields, event)
  when /types?/i
    fields = char_type(character, fields)
  when /status/i
    fields = char_status(character, fields)
  when /rumors?/i
    fields = char_rumors(character, fields)
  when /images?/i
    image = image ? image : default_img
    if image
      embed.title =
        "#{character.name} | #{image.keyword}" unless image.keyword == 'Default'
      embed.image = { url: image.url }

      # Replace the rating with the image's rating
      footer_info.pop
      footer_info.push(image.category)
    else
      embed.description = "No character images found!"
    end

    # Remove default image
    embed.thumbnail = nil
  when /bags?/i, /inventory/i
    fields = char_inv(character, fields)
  when /journal/i
    fields = char_journal(character, fields, journal)
  when /forms?/i, /alt(ernate)?\sforms?/i
    fields = alt_form_embed(character, fields)
  end

  # Add fields to embed
  embed.fields = fields

  # Add ID to footer, and apply to embed
  footer_info.push(character.id)
  author_footer(embed, member, footer_info)
end

def char_alias(char, fields)
  fields.push(
    { name: 'Known Aliases', value: char.aliases.join(', ') }
  )if char.aliases

  fields
end

def char_bio(char, fields)
  # Find the appropriate teams
  char_teams = CharTeam.where(char_id: char.id, active: true).map(&:team_id)
  teams = Team.where(id: char_teams).map(&:name)

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
    { name: 'Recent Events', value: char.recent_events }
  )if char.recent_events
  fields.push(
    { name: 'Other', value: char.other }
  )if char.other
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
  # Find any status effects on the character
  status_effects = CharStatus.where(char_id: char.id)

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

def char_inv(char, fields)
  # Retrive array of [item amount, item name], and format
  inv = char.fetch_inventory
  bags = inv.map { |i| i[0] > 1 ? "#{i[1]} [#{i[0]}]" : i[1] }

  # Show formatted items
  value = bags.empty? ? "#{char.name} doesn't have any items" : bags.join("\n")
  fields.push({ name: "Bags", value: value })

  fields
end

def char_journal(char, fields, journal)
  if journal.is_a? JournalEntry
    fields.push({ name: journal.title, value: journal.entry })
  elsif journal.empty?
    fields.push({ name: 'Error', value: 'No journal entries found' })
  else
    # Display each journal entry
    journal.each do |j|
      fields.push({ name: j&.title || j.date, value: j.entry })
    end
  end

  fields
end

def char_dm_notes(char, fields, event)
  return fields unless ENV['DMS_GROUP'].include?(event.channel.id.to_s)

  fields.push(
    { name: 'DM Notes', value: char.dm_notes }
  )if char.dm_notes

  fields
end

def char_list_embed(chars, group, sort = nil)
  fields = []
  list = {}

  case group
  when /active/i
    title = "Registered Guild Members -- [#{chars.count}]"
    desc = "These are the pokemon registered to the guild, sorted by primary type"
  when /archived/i
    title = "Archived Guild Members -- [#{chars.count}]"
    desc = "These are the pokemon in the guild archives, sorted by primary type"
  when /npc/i
    title = "Registered Guild NPCs -- [#{chars.length}]"
    desc = "These are the NPCs from all around Zaplana, sorted by current location"
  when /special/i
    title = "Special Characters -- [#{chars.count}]"
    desc = "These are the special pokemon around Zaplana, sorted by category"
  end

  case sort&.first
  when Type
    sort.each do |s|
      list[s.name] = chars.map do |c|
        next unless c.types.split("/").first === s.name
        name = c.name
        name = "|| #{name} ||" if c.rating&.match(/NSFW/i)
        name
      end.compact
    end

    list = list.reject { |k,v| v == [] }
    list.each do |k,v|
      fields.push({ name: k, value: v.join(", ") })
    end
  when Region
    sort.each do |s|
      list[s.name] = chars.map do |c|
        next unless c.region == s.name
        name = c.name
        name = "*#{name}*" if c.user_id.match(/public/i)
        name = "|| #{name} ||" if c.rating&.match(/NSFW/i)
        name
      end.compact
    end


    list["Unknown"] = chars.map do |c|
      next unless c.region.nil?
      name = c.name
      name = "*#{name}*" if c.user_id.match(/public/i)
      name = "|| #{name} ||" if c.rating&.match(/NSFW/i)
      name
    end.compact

    list = list.reject { |k,v| v == [] }
    list.each do |k,v|
      fields.push({ name: k, value: v.join(", ") })
    end
  when nil
    list["guild"] = []
    list["adoptable"] = []
    list["legend"] = []

    chars.each do |c|
      case c.special
      when /legend/i
        list["legend"].push("#{c.name}, #{c.species} -- last seen: #{c.location || "???"}")
      when /guild/i
        list["guild"].push("#{c.name}, #{c.species}")
      else
        list["adoptable"].push("#{c.name}, #{c.species} -- #{c.location || "???"}")
      end
    end

    list = list.reject { |k,v| v == [] }
    list.each do |k,v|
      case k
      when /legend/i
        fields.push({ name: "Mythic/Legend Pokemon", value: v.join("\n") })
      when /guild/i
        fields.push({ name: "Guild Employees", value: v.join("\n") })
      when /adoptable/i
        fields.push({ name: "Adoptable NPCs", value: v.join("\n") })
      end
    end
  end

  if fields.empty?
    fields.push({name: "No Resulst", value: "--"})
  end

  Embed.new(
    title: title,
    description: desc,
    fields: fields,
    footer: {
      text: "React to Navigate | 1. Active | 2. Archived | 3. NPCs | 4. Special"
    }
  )
end

def user_char_embed(chars, member, event, nsfw=nil)
  fields = []
  active = []
  archived = []
  npcs = []
  deleted = []
  user_name = member&.nickname || member&.name || "Unknown User"

  chars.each do |char|
    case char.active
    when 'Active'
      active.push char
    when 'Archived'
      archived.push char.name
    when 'NPC'
      npcs.push char.name
    when 'Deleted'
      deleted.push char.name
    end
  end

  active.each.with_index do |char, i|
    name = nsfw && char.rating == 'NSFW' ?
      "#{Emoji::NUMBERS[i]} || #{char.name} ||" : "#{Emoji::NUMBERS[i]} #{char.name}"
    fields.push({
      name: name,
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

  unless deleted.empty? && !ENV['GMS_GROUP'].include?(event.channel.id.to_s)
    fields.push({ name: "#{user_name}'s Deleted Characters", value: deleted.join(", ") })
  end

  # Find allowed active characters
  allowed = member ? User.find(member.id.to_s).allowed_chars(member) : '???'

  embed = Embed.new(
    title: "#{user_name}'s Characters [#{active.count}/#{allowed}]",
    description: "Click on the corresponding reaction to view the character",
    fields: fields
  )

  embed.color = member&.color&.combined if member&.color
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

def alt_form_embed(char, fields)
  # Find Base Character Form
  chars = []
  if char.alt_form
    chars.push( Character.find(char.alt_form) )
  else
    chars.push(char)
  end

  # Add forms
  chars.concat( Character.where(alt_form: chars.first.id) )

  # Display forms
  chars.each.with_index do |char, i|
    fields.push({
      name: "#{Emoji::NUMBERS[i]} #{char.name}",
      value: "#{char.species} -- #{char.types}"
    })
  end

  # return fields
  fields
end

def image_list_embed(character, event)
  # Find the author, if they're a member, or in DMs use the event's author
  if event.server
    member = character.user_id.match(/public/i) ? 'Public' :
      event.server.member(character.user_id)
  else
    member = event.author
  end
  # Grab an array of the character's images
  images = CharImage.where(char_id: character.id).
    map{ |i| "[#{i.keyword}](#{i.url})" }

  # Create Embed
  embed = Embed.new(
    title: character.name,
    description: images.join("\n"),
    color: character.type_color
  )

  # Add footer to embed
  author_footer(embed, member, [character.active, character.id])
end

def nsfw_char_embed(character, event)
  # Find the author, if they're a member,
  member = event.server.member(character.user_id)

  # Create Embed
  embed = Embed.new(
    title: character.name,
    color: character.type_color,
    fields: [{
      name: 'Wrong Channel!',
      value: 'The requested information contains NSFW content'
    }]
  )
  embed.thumbnail = nil

  # Apply appropriate footer to embed
  author_footer(embed, member, [character.active, character.rating, character.id])
end
