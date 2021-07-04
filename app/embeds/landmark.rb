NO_GOLD = 'https://cdn.discordapp.com/attachments/645493256821669888/683732758199140387/fcece3957f27d25f9c7aee13a89b7e7c.png'

def landmark_embed(lm:, section: nil, event: nil)
  # Find the author, if they're a member
  author = event.server.member(lm.user_id)
  fields = []

  embed = Embed.new(
    title: lm.name,
    description: lm.description
  )

  # Add default image and footer
  embed.thumbnail = { url: lm.url }
  author_footer(embed, author, [lm.category, lm.id])

  # Fill out the fields based on section
  case section
  when /history/i, nil
    # Parent Landmark
    fields.push(
      { name: 'Location', value: Landmark.find(lm.location).name, inline: true }
    ) if lm.location

    # Region
    fields.push(
      {name: 'Region', value: Region.find(lm.region).name, inline: true}
    )

    # History and Folklore
    fields.push({name: 'History', value: lm.history}) if lm.history
    fields.push({name: 'Folklore', value: lm.folk_lore}) if lm.folk_lore
  when /warning/i
    # Ensure we aren't looking for NSFW material in a SFW channel
    hide = !event.channel.nsfw? && lm.w_rating == 'NSFW'

    # List Kinks, Show warning, or hide if needed
    fields.push({name: 'Kinks', value: lm.kink.join("\n")}) if lm.kink
    fields.push(
      {name: 'Warning', value: hide ? 'This warning is NSFW!' : lm.warning}
    ) if lm.warning

    # Display appropriate image
    embed.thumbnail = { url: hide ? NO_GOLD : lm.w_url }
  when /map/i
    # Display map, if it exists
    lm.map_url ?
      embed.image = { url: lm.map_url } : embed.description = 'No Map Data'

    # Remove default image
    embed.thumbnail = nil
  when /layout/i
    # Display layout map, if it exists
    lm.layout_url ?
      embed.image = { url: lm.layout_url } : embed.description = 'No Layout Data'

    # Remove default image
    embed.thumbnail = nil
  when /npcs?/i
    # Find NPCs in the landmark, case insensitive
    npcs = Character.where('location ilike ?', lm.name)
      .map{ |npc| "#{npc.name} - #{npc.species}" }

    # List NPCs that currently reside in this landmark
    fields.push({
      name: 'NPC Residents',
      value: npcs.empty? ? 'No known inhabitants' : npcs.join("\n")
    })
  end

  # Update fields and return embed
  embed.fields = fields
  embed
end

def landmark_list
  fields = []

  # Fetch all the Regions, and iterate through them
  Region.all.each do |r|
    # Fetch the all the Landmarks inside the region, then iterate
    landmarks = Landmark.where(region: r.id)
    children, parents = landmarks.partition{ |lm| lm.location }
    list = []

    parents.each do |p|
      list.push(p.name)

      input_children(children, p, list, 1)
    end

    fields.push({ name: r.name, value: list.join("\n"), inline: true}) unless landmarks.empty?
  end

  Embed.new(
    title: 'Places of Interest',
    fields: fields
  )
end

def input_children(children, parent, list, level)
  indent = "---"

  children.filter{ |c| c.location == parent.id }.each do |landmark|
    list.push("#{indent*level}#{landmark.name}")

    input_children(children, landmark, list, level+1)
  end
end

def filtered_landmarks(landmarks, filters)
  fields = []
  Region.all.each do |r|
    list = landmarks.select{ |lm| lm.region == r.id }.map(&:name)
    fields.push({ name: r.name, value: list.join("\n"), inline: true }) unless list.empty?
  end

  Embed.new(
    title: "Places of Interest: #{filters.join(', ')}",
    fields: fields
  )
end
