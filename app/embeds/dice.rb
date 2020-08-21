def dice_list
  # Fetch all saved dice
  dice = DieArray.all
  fields = []

  # Insert each die into a field
  dice.each do |die|
    fields.push({ name: die.name, value: die.sides.join(", ") })
  end

  # Create Embed
  embed = Embed.new(
    title: "Available Dice",
  )

  # Update with fields, or a message of no dice, and reply
  fields.empty? ? embed.description = 'No dice found' : embed.fields = fields
  embed
end

def roll_results(author, hash, combine=false)
  # Create standard embed
  embed = Embed.new(
    author: {
      name: author.nickname || author.name,
      icon_url: author.avatar_url
    },
    color: author.color&.combined
  )

  case hash[:sides]
  when Integer
    # Fill the fields with results unless set to combine
    embed = fill_result_fields(hash[:results], embed) unless combine

    # Fill the description with tallied total, and footer with the rolled dice
    total = hash[:modifier].to_i + hash[:results].sum
    embed.description = "Rolled a total Result of **#{total}**"
    embed.footer = { text: "Rolled #{hash[:number]} D#{hash[:sides]}, modifier: #{hash[:modifier] || 'none'}" }

  when Array
    # Fill the fields with results, and add the die to the footer
    embed = fill_result_fields(hash[:results], embed)
    embed.footer = { text: "Rolled #{hash[:sides].join(', ')}" }
  end

  embed
end

def fill_result_fields(results, embed)
  fields = []

  results.each do |r|
    fields.push({ name: 'Result', value: "#{r}", inline: true })
  end

  embed.fields = fields
  embed
end
