require './app/app_forms/app_form.rb'

class ReactivationApplication < ApplicationForm
  def self.process
    @process ||= Application.new('Reactivation Application') do |event|
      # Calculate majority and Save application
      maj = majority(event)

      # Check votes
      reactions = event.message.reactions
      if reactions[Emoji::Y]&.count.to_i > maj && star(event)
        approve(event)
      elsif reactions[Emoji::N]&count.to_i > maj
        deny(event)
      elsif reactions[Emoji::CRAYON]&count.to_i > maj
        edit(event)
      elsif reactions[Emoji::CROSS]&.count.to_i > 1
        remove(event)
      end
    #rescue StandardError => e
      #error_embed(e.message)
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
      reactions: CharApp::REJECT_MESSAGES.map{ |k,v| k }
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
