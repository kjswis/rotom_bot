require './app/app_forms/app_form.rb'

class TeamJoinApplication < ApplicationForm
  def self.process
    @process ||= Application.new('Team Join Request') do |event|
      # Calculate majority and check votes
      maj = majority(event)
      reactions = event.message.reactions

      if reactions[Emoji::Y]&.count.to_i > maj
        approve(event)
      elsif reactions[Emoji::N]&.count.to_i > maj
        deny(event)
      end
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.approve(event)
    # Save the app, character, and team
    app = event.message.embeds.first

    character = Character.find(app.footer.text.split(/\s?\|\s?/).last)
    team = Team.find_by!(channel: event.channel.id)

    # Add the character to the team
    team.join(character, event)
    member = event.server.member(character.user_id)
    member.add_role(team.role.to_i)

    # Welcome them to new team!
    reply = BotResponse.new(
      destination: team.channel,
      text: "Welcome #{character.name} to the team!"
    )

    event.message.delete
    reply
  end

  def self.deny(event)
    # Save the app, character, and team
    app = event.message.embeds.first

    character = Character.find(app.footer.text.split(/\s?\|\s?/).last)
    team = Team.find_by!(channel: event.channel.id)

    # Notify the requester of denial
    reply = BotResponse.new(
      destination: ENV['TEAM_CH'],
      text: "#{character.name}'s request to join #{team.name} has been denied"
    )

    event.message.delete
    reply
  end

  def self.majority(event)
    # Find the corresponding team
    team = Team.find_by!(channel: event.channel.id)

    # The total number of voters, divided by 2, +1
    (event.server.roles.find{ |r| r.id == team.role.to_i }.
      members.count / 2) + 1
  end
end
