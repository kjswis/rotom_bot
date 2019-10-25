class ImageController
  def self.default_image(url, char_id)
    img = CharImage.where(char_id: char_id).find_by(keyword: 'Default')

    case
    when url && img
      img.update(url: url)
      img.reload
    when url && !img
      img = CharImage.create(
        char_id: char_id,
        url: url,
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

  def self.img_scroll(char_id: , nsfw: false, img: nil, dir: nil)
    imgs = nsfw ? CharImage.where(char_id: char_id) :
      CharImage.where(char_id: char_id, category: 'SFW' )

    cur_i = img ? imgs.index { |i| i[:id] == img } : imgs.length - 1

    case dir
    when :left
      nex_i = cur_i == 0 ? imgs.length - 1 : cur_i - 1
    else
      nex_i = cur_i == imgs.length - 1 ? 0 : cur_i + 1
    end

    imgs[nex_i]
  end
end
