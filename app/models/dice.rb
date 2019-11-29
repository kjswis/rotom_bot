class DieArray < ActiveRecord::Base
  validates :sides, presence: true
end
