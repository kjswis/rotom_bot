TEAM_BLUE = "#3498db"

def team_embed(team)
  fields = []
  active = []
  members = CharTeam.where(team_id: team.id)

  members.each do |member|
    if member.active
      active.push(Character.find(member.char_id).name)
    end
  end

  fields.push({
    name: 'Active Members',
    value: active.join(", ")
  })unless active.empty?

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

def team_alert(char, teams)
  Embed.new(
    author: { name: 'Team Alert' },
    description: "By archiving #{char.name}, you will be removed from " +
      "#{teams.join(" & ")}\n**Are you sure?**",
    footer: { text: char.id },
    color: TEAM_BLUE
  )
end
