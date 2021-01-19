class JournalEntry < ActiveRecord::Base
  validates :char_id, presence: true
  validates :date, presence: true
  validates :entry, presence: true
end
