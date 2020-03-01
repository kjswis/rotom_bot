class LandmarkNpcs < ActiveRecord::Base
  validates :character_id, presence: true
  validates :landmark_id, presence: true
end
