class CharTeam < ActiveRecord::Base
  validates :team_id, presence: true
  validates :char_id, presence: true
end
