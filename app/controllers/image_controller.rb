class ImageController
  def self.default_image(content, char_id)
    if image_url = /\*\*URL to the Character\'s Appearance\*\*\:\s(.*)/.match(content)
      if image = CharImage.where(char_id: char_id).find_by(keyword: 'Default')
        image.update(url: image_url[1])
        image.reload
      else
        image = CharImage.create(char_id: char_id, url: image_url[1], category: 'SFW', keyword: 'Default')
      end

    end

    image ? image.url : image_url[1]
  end

  def self.edit_image(params)
    img_hash = CharImage.from_form(params)

    if image = CharImage.where(char_id: img_hash["char_id"]).find_by(keyword: img_hash["keyword"])
      image.update!(img_hash)
      image.reload
    else
      image = CharImage.create(img_hash)
    end

    image
  end
end
