def show_stats(user, member)
  rows = []
  rows << ['', 'Current', 'Base', 'IVs']
  rows << :separator
  rows << ['HP', user.hp, user.hp_base, user.hp_iv]
  rows << ['A', user.attack, user.a_base, user.a_iv]
  rows << ['D', user.defense, user.d_base, user.d_iv]
  rows << ['SA', user.sp_attack, user.sa_base, user.sa_iv]
  rows << ['SD', user.sp_defense, user.sd_base, user.sd_iv]
  rows << ['S', user.speed, user.s_base, user.s_iv]

  stats = Terminal::Table.new rows: rows

  embed = Embed.new(
    title: member.nickname || member.name,
    description: "```#{stats.to_s}```",
  )

  embed.color = member.color.combined if member.color
  embed
end
