require './app/app_forms/app_form.rb'

class ReactivationApplication < ApplicationForm
  def self.process
    @process ||= Application.new('Reactivation Application') do |event|
      # Calculate majority and check votes
      maj = majority(event)
      check_votes(event, maj)

    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.approve(event)
    app = event.message.embeds.first

    # Find Character
    character = Character.find(app.footer.text.match(/\|\s(\d+)$/)[1])

    # Reactivate and reload
    character.update(active: 'Active')
    character.reload

    # Determine appropriate channel
    channel = case character.rating
              when /sfw/i then ENV['CHAR_CH']
              when /nsfw/i then ENV['CHAR_NSFW_CH']
              when /hidden/i then member.dm
              end

    # Create reply
    reply = BotResponse.new(
      destination: channel,
      text: "Good News, <@#{character.user_id}>! your character was approved!",
      embed: character_embed(character: character, event: event)
    )

    # Delete app from approval channel, and reply
    event.message.delete
    reply
  end

  def self.deny(event)
    # Create App Rejection
    reply = BotResponse.new(
      embed: reject_app(event.message.embeds.first, :reactivation),
      reactions: CharApp::REJECT_MESSAGES.map{ |k,v| k }.push(Emoji::CHECK)
    )

    # Delete app, and reply
    event.message.delete
    reply
  end

  def self.edit(event)
    app = event.message.embeds.first

    # Find Character
    character = Character.find(app.footer.text.match(/\|\s(\d+)$/)[1])

    # Create link embed
    reply = BotResponse.new(
      destination: event.channel.id,
      embed: self_edit_embed(character.edit_url, Url::CHARACTER),
      timer: 35
    )

    # Delete app and reply
    event.message.delete
    reply
  end
end
