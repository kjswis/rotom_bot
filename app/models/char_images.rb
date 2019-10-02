class CharImages < ActiveRecord::Base
  validates :char_id, presence: true
  validates :url, presence: true
end
