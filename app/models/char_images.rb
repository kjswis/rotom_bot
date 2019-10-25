class CharImage < ActiveRecord::Base
  validates :char_id, presence: true
  validates :url, presence: true

  def self.from_form(app)
    key_mapping = {
      "Keyword" => "keyword",
      "Category" => "category",
    }

    hash = {}
    app.fields.each do |field|
      next if field.nil?

      db_column = key_mapping[field.name]
      hash[db_column] =
        db_column == 'category' ? field.value.upcase : field.value
    end

    hash["char_id"] = app.footer.text
    hash["url"] = app.image.url

    hash = hash.reject { |k,v| k == nil }
    hash
  end

  def self.to_form(char:, keyword:, category:, url:, user_id:)
    Embed.new(
      title: "#{char.name} | #{char.species}",
      description: "<@#{user_id}>",
      author: {
        name: "Image Application",
        icon_url: "https://i.imgur.com/fiLLQED.jpg"
      },
      image: {
        url: url
      },
      footer: {
        text: char.id
      },
      fields: [
        { name: 'Keyword', value: keyword, inline: true },
        { name: 'Category', value: category, inline: true }
      ]
    )
  end
end
