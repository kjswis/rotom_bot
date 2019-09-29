class Character < ActiveRecord::Base
  validates :user_id, presence: true
  validates :name, presence: true
  validates :species, presence: true
  validates :types, presence: true
end
