class Image < ActiveRecord::Base
  validates :name, presence: true
  validates :url, presence: true
end
