class CharImage < ActiveRecord::Base
  validates :char_id, presence: true
  validates :url, presence: true

  def self.from_form(params)
    key_mapping = {
      "**Character ID**" => "char_id",
      "**Keyword**" => "keyword",
      "**Category**" => "category",
      "**URL**" => "url"
    }

    hash = {}

    params.map do |item|
      next if item.empty?

      key,value = item.split(": ")
      db_column = key_mapping[key]

      if db_column == "category"
        hash[db_column] = value.upcase
      else
        hash[db_column] = value
      end
    end

    hash = hash.reject { |k,v| k == nil }
    hash
  end
end
