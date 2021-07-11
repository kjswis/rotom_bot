class Fable < ActiveRecord::Base
  validates :title, presence: true
  validates :story, presence: true

  MAPPING = {
    "Author" => "user_id",
    "Keywords" => "keywords",
    "Book Name" => "title",
    "Story" => "story",
    "Image URL" => "url"
  }

  def self.from_form(app)
    hash = {
      "title" => nil,
      "story" => nil,
      "url" => nil,
      "keywords" => nil,
      "user_id" => nil,
      "edit_url" => nil
    }

    hash["title"] = app.title
    hash["story"] = app.description
    hash["edit_url"] = app.footer.text
    hash["url"] = app.image&.url

    app.fields.each do |field|
      next if field.nil?

      db_column = key_mapping[field.name]
      if db_column == "user_id"
        hash[db_column] = UID.match(field.value)[1]
      elsif db_column == "keywords"
        hash[db_column] = field.value.split(/\s?(,|\|)\s?/)
      else
        hash[db_column] = field.value
      end
    end


    hash = hash.reject { |k,v| k == nil }
    hash
  end
end
