require './app/app_forms/app_form.rb'

class TeamApplication < ApplicationForm
  def self.process
    @process ||= Application.new('Team Application') do |event|
      # Calculate majority, and check votes
      maj = majority(event)
      reactions = event.message.reactions

      if reactions[Emoji::Y]&.count.to_i > maj && star(event)
        approve(event)
      elsif reactions[Emoji::N]&.count.to_i > maj
        deny(event)
      elsif reactions[Emoji::Cross]&.count.to_i > 1
        remove(event)
      end
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.approve(event)
    # Save the application
    app = event.message.embeds.first

    # Create Role
    role = event.server.create_role(
      name: app.title,
      colour: 3447003,
      hoist: true,
      mentionable: true,
      reason: 'New Team'
    )

    # Sort the Team above Clubs
    role.sort_above(ENV['TEAM_ROLE'])

    # Create Channel
    channel = event.server.create_channel(
      app.title,
      parent: ENV['TEAM_CAT'],
      permission_overwrites: [
        { id: event.server.everyone_role.id, deny: 1024 },
        { id: role.id, allow: 1024 }
      ]
    )

    # Create new team
    team = Team.create(
      name: app.title,
      description: app.description,
      role: role.id.to_s,
      channel: channel.id.to_s
    )

    reply = BotResponse.new(
      destination: ENV['TEAM_CH'],
      embed: message_embed(
        "#{team.name} was approved!",
        "Request to join with ```pkmn-team #{team.name} | apply | character_name```"
      )
    )

    event.message.delete
    reply
  end

  def self.deny(event)
    event.message.delete
  end
end
