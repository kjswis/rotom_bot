def show_stats(usr, member)
  rows = []
  rows << ['', 'Current', 'Base', 'IVs']
  rows << :separator
  rows << ['HP', usr.hp, usr.hp_base, usr.hp_iv]
  rows << ['A', usr.attack, usr.a_base, usr.a_iv]
  rows << ['D', usr.defense, usr.d_base, usr.d_iv]
  rows << ['SA', usr.sp_attack, usr.sa_base, usr.sa_iv]
  rows << ['SD', usr.sp_defense, usr.sd_base, usr.sd_iv]
  rows << ['S', usr.speed, usr.s_base, usr.s_iv]

  stats = Terminal::Table.new rows: rows

  embed = Embed.new(
    title: member.nickname || member.name,
    description: "```#{stats.to_s}```",
  )

  embed.color = member.color.combined if member.color
  embed
end
