class CharStatus < ActiveRecord::Base
  validates :char_id, presence: true
  validates :status_id, presence: true
end
