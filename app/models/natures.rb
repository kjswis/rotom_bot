class Nature < ActiveRecord::Base
  validates :name, presence: true
end
