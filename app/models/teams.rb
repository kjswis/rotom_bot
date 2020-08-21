class Team < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true

  def join(character, event)
    existing_row = CharTeam.where(char_id: character.id, team_id: id)

    if existing_row.empty?
      CharTeam.create(char_id: character.id, team_id: id, active: true)
    else
      existing_row.update(active: true)
    end
  end

  def leave(char)
    # Find the char_team row, update it to inactive
    ct = CharTeam.where(team_id: id).find_by!(char_id: char.id)
    ct.update(active: false)

    # Check if they have any members left in the team
    # Special Query
    sql = "SELECT * " +
      "FROM char_teams JOIN characters " +
      "ON char_teams.char_id = characters.id " +
      "WHERE characters.user_id = ? " +
      "AND char_teams.team_id = ? " +
      "and char_teams.active = true;"
    # Execute
    sql = ActiveRecord::Base.send(:sanitize_sql_array, [sql, char.user_id, id])
    remaining_chars = ActiveRecord::Base.connection.exec_query(sql)

    # Return if the user should have team role removed
    remaining_chars.count == 0
  rescue ActiveRecord::RecordNotFound => e
    error_embed(e.message)
  end

  def archive(event)
    # Update each character team status to false, then the team
    CharTeam.where(team_id: id).update(active: false)
    update(active: false)

    # Delete Server Role, and move channel
    event.server.role(role_id).delete('Archived Team')
    event.channel.category=(ENV['TEAM_ARCHIVES'])
  end
end
