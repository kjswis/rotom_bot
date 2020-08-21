def create_request(name, desc)
  Embed.new(
    title: name,
    description: desc,
    author:{
      name: 'Team Application'
    }
  )
end

def join_request(char, user)
  # Grab the character's default image
  img = CharImage.where(char_id: char.id).find_by(keyword: 'Default')

  embed = Embed.new(
    title: "#{char.name} would like to join your team!",
    description: "Please react to indicate if you'd like them to join!",
    author: { name: 'Team Join Request' }
  )

  # Build footer to show the character's user, and id
  # Attatch character image, if it exists
  author_footer(embed, user, [char.id])
  embed.thumbnail = { url: img.url } if img

  # Return
  embed

end
