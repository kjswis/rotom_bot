class User < ActiveRecord::Base
  validates :id, presence: true
end
