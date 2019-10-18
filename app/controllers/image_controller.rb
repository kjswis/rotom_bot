class ImageController
  def self.default_image(content, char_id)
    img_url =
      /\*\*URL to the Character\'s Appearance\*\*\:\s(.*)/.match(content)
    img = CharImage.where(char_id: char_id),find_by(keyword: 'Default')

    case
    when img_url && img
      img.update(url: img_url[1])
      img.reload
    when img_url && !img
      img = CharImage.create(
        char_id: char_id,
        url: img_url[1],
        category: 'SFW',
        keyword: 'Default'
      )
    end

    img
  end

  def self.edit_image(params)
    img_hash = CharImage.from_form(params)
    char_id = img_hash["char_id"]
    keyword = img_hash["keyword"]

    img = CharImage.where(char_id: char_id).find_by(keyword: keyword)

    if img
      img.update!(img_hash)
      img.reload
    else
      img = CharImage.create(img_hash)
    end

    img
  end
end
