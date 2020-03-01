class Landmark < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :category, presence: true
end
