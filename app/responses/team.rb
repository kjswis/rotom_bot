TEAM_BLUE = "#3498db"

def new_team_embed(user, team_name, desc)
  footer_text = "#{user.name}##{user.tag}"
  footer_text += " | #{user.nickname}" if user.nickname

  Embed.new(
    title: team_name,
    description: desc,
    color: TEAM_BLUE,
    author: {
      name: 'Team Application'
    },
    footer: {
      text: footer_text,
      icon_url: user.avatar_url
    }
  )
end

def team_embed(team)
  fields = []
  active = []
  inactive = []
  members = CharTeam.where(team_id: team.id)

  members.each do |member|
    if member.active
      active.push(Character.find(member.char_id).name)
    else
      inactive.push(Character.find(member.char_id).name)
    end
  end

  fields.push({
    name: 'Active Members',
    value: active.join(", ")
  })unless active.empty?

  fields.push({
    name: 'Former Members',
    value: inactive.join(", ")
  })unless inactive.empty?

  embed = Embed.new(
    title: team.name,
    color: TEAM_BLUE,
    fields: fields
  )

  embed.description = team.description if team.description
  embed
end

def teams_embed
  fields = []
  active = []
  inactive = []

  teams = Team.all
  teams.each do |team|
    if team.active
      active.push(team.name)
    else
      inactive.push(team.name)
    end
  end

  fields.push({
    name: 'Active Teams',
    value: active.join(", ")
  })unless active.empty?

  fields.push({
    name: 'Inactive Teams',
    value: inactive.join(", ")
  })unless inactive.empty?

  Embed.new(
    title: 'Rescue Teams',
    description: 'Use `pkmn-team team_name` to learn more',
    color: TEAM_BLUE,
    fields: fields
  )
end

def team_app_embed(team, char, user)
  footer_text = user ? "#{user.name}##{user.tag}" : "Public NPC"
  footer_text += " | #{user.nickname}" if user && user.nickname
  footer_text += " | #{char.id}"

  img = CharImage.where(char_id: char.id).find_by(keyword: 'Default')

  embed = Embed.new(
    title: "#{char.name} would like to join your team!",
    description: "Please react to indicate if you'd like them to join!",
    author: { name: 'Team Join Request' }
  )

  embed.footer = user ?
    { text: footer_text, icon_url: user.avatar_url } : { text: footer_text }
  embed.thumbnail = { url: img.url } if img
  embed
end
