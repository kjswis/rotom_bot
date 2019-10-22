class Carousel < ActiveRecord::Base
  validates :message_id, presence: true
  validates :char_id, presence: true
end
