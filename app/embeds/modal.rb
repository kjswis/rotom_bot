def journal_modal(journal)
  instructions = %Q[
    In order to edit any of the fields, input:
    ```pkmn-journal #{journal.id} | field | updated information```
  ]

  character = Character.find(journal.char_id)

  Embed.new(
    title: 'Journal Entry!',
    description: instructions,
    fields: [
      { name: 'Character', value: character.name },
      { name: 'Title', value: journal.title },
      { name: 'Entry', value: journal.entry },
      { name: 'Date', value: journal.date },
    ],
    footer: {
      text: 'Press Y to confirm new Journal, or N to discard and delete it'
    }
  )
end
