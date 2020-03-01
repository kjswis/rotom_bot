def landmark_embed(lm:, user: nil, section: nil, event: nil)
  fields = []
  icon = nil

  user_name = case user
              when /Server/i
                icon = event.server.icon_url if event
                'Server Owned'
              when nil
                icon = UNKNOWN_USER_IMG
                'Unknown Creator'
              else
                icon = user.avatar_url
                "#{user.name}##{user.tag}"
              end

  r = Region.find(lm.region)
  plm = Landmark.find(lm.location)
  npcs = []
  npc_list = LandmarkNpcs.where(landmark_id: lm.id)
  npc_list.each do |lmnpc|
    npc = Character.find(lmnpc.character_id)
    npcs.push "#{npc.name} - #{npc.species}"
  end

  inhabitants = npcs.empty? ? 'No known inhabitants' : npcs.join("\n")

  embed = Embed.new(
    footer: {
      text: "#{user_name} | #{lm.category} | #{lm.rating}"
    },
    title: lm.name
  )

  case section
  when :history, nil
    embed.description = lm.description
    embed.thumbnail = { url: lm.url } if lm.url

    fields.push({name: 'Location', value: plm.name, inline: true}) if lm.location
    fields.push({name: 'Region', value: r.name, inline: true}) if r
    fields.push({name: 'History', value: lm.history}) if lm.history
    fields.push({name: 'Folk Lore', value: lm.folk_lore}) if lm.folk_lore
  when :warning
    embed.description = lm.description
    embed.thumbnail = { url: lm.w_url } if lm.w_url

    fields.push({name: 'Kinks', value: lm.kink.join("\n")}) unless lm.kink.empty?
    fields.push({name: 'Warning', value: lm.warning}) if lm.warning
  when :map
    if lm.map_url
      embed.image = { url: lm.map_url }
    else
      embed.description = 'No Map Data'
    end
  when :layout
    if lm.layout_url
      embed.image = { url: lm.layout_url }
    else
      embed.description = 'No Layout Data'
    end
  when :npcs
    embed.description = lm.description
    embed.thumbnail = { url: lm.url } if lm.url

    fields.push({name: 'NPC Residents', value: inhabitants})
  end

  embed.fields = fields
  embed.footer.icon_url = icon

  embed
end

def landmark_list
  fields = []
  rs = Region.all

  rs.each do |r|
    lms = Landmark.where(region: r.id)

    fields.push({ name: r.name, value: lms.map(&:name).join("\n") }) unless lms.empty?
  end

  Embed.new(
    title: 'Places of Interest',
    fields: fields
  )
end
