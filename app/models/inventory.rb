class Inventory < ActiveRecord::Base
  validates :item_id, presence: true
end
