class ImageController
  def self.edit_images(content, char_id)
    if image_url = /\*\*URL to the Character\'s Appearance\*\*\:\s(.*)/.match(content)
      unless CharImages.where(char_id: char_id).find_by(url: image_url[1])
        image = CharImages.create(char_id: char_id, url: image_url[1], category: 'SFW', keyword: 'Primary')
      end
    end

    image
  end
end
