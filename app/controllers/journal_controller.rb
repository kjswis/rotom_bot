class JournalController
  def self.journal_scroll(char_id:, page:, dir:)
    total_journals = JournalEntry.where(char_id: char_id).length

    new_page = case dir
               when :left
                 page <= 1 ? total_journals / 10 + 1 : page - 1
               when :right
                 page >= total_journals / 10 + 1 ? 1 : page + 1
               else
                 1
               end

    new_page
  end

  def self.fetch_page(char_id, page)
    JournalEntry.where(char_id: char_id).
      slice(page*10 - 10 .. page*10-1)
  end
end
