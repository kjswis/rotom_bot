class ConfirmArchive < ApplicationForm
  def self.process
    @process ||= Application.new('Team Alert') do |event|
      # Check reactions
      reactions = event.message.reactions
      if reactions[Emoji::Y]&.count.to_i > 1
        approve(event)
      elsif reactions[Emoji::N]&.count.to_i > 1
        deny(event)
      end
    #rescue StandardError => e
      #error_embed(e.message)
    end
  end

  def self.approve(event)
    app = event.message.embeds.first
    character = Character.find(app.footer.text.to_i)

    # Check users that reacted, execute on authorized user
    ys = event.message.reacted_with(Emoji::Y)
    ys.each do |y|
      member = event.server.member(y.id)
      if character.user_id = y.id || Util::Roles.admin?(member)
        char_teams = CharTeam.where(char_id: character.id)
        char_teams.each do |ct|
          team = Team.find(ct.team_id)
          team.leave(character)
        end

        binding.pry
        character.update(active: 'Archived')

        embed = success_embed("Successfully Archived #{character.name}")
        event.message.delete
        [BotResponse.new(destination: ENV['APP_CH'], embed: embed),
         BotResponse.new(embed: embed)]
      end
    end
  end

  def self.deny(event)
    app = event.message.embeds.first
    character = Character.find(app.footer.text.to_i)

    ns = event.message.reacted_with(Emoji::N)
    ns.each do |n|
      member = event.server.member(n.id)
      event.message.delete if character.user_id = n.id || Util::Roles.admin?(member)
    end
  end
end
