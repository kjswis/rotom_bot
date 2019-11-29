def dice_embed
  dice = DieArray.all
  d = []

  dice.each do |die|
    d.push("**#{die.name}**: #{die.sides.join(", ")}")
  end

  desc = d.empty? ? 'No available dice' : d.join("\n")

  Embed.new(
    title: "Available Dice",
    description: desc
  )
end
