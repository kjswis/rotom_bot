require './app/app_forms/app_form.rb'

class CharacterApplication < ApplicationForm
  def self.process
    @process ||= Application.new('Character Application') do |event|
      # Calculate majority, and check votes
      maj = majority(event)
      check_votes(event, maj)

    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.approve(event)
    # Save the application, and member if they exist
    app = event.message.embeds.first
    user_id = app.description.match(UID)
    member = event.server.member(user_id[1])

    # Save character and default image
    character = CharacterController.edit_character(app)
    ImageController.default_image(app.image&.url, character.id, character.rating)

    # Determine appropriate channel
    channel = case character.rating
              when /sfw/i then ENV['CHAR_CHANNEL']
              when /nsfw/i then ENV['NSFW_CHANNEL']
              when /hidden/i then member.dm
              end

    # Create reply
    reply = BotResponse.new(
      destination: channel,
      text: "Good News, <@#{character.user_id}>! Your character was approved!",
      embed: character_embed(character: character, event: event)
    )

    # Delete app from approval channel, and reply
    event.message.delete
    reply
  end

  def self.deny(event)
    # Create App Rejection
    reply = BotResponse.new(
      embed: reject_app(event.message.embeds.first, :character),
      reactions: CharApp::REJECT_MESSAGES.map{ |k,v| k }.push(Emoji::CHECK)
    )

    # Delete app, and reply
    event.message.delete
    reply
  end

  def self.edit(event)
    # Save the application
    app = event.message.embeds.first

    # Create link embed
    reply = BotResponse.new(
      destination: event.channel.id,
      embed: self_edit_embed(app.footer.text, Url::CHARACTER),
      timer: 35
    )

    # Delete app and reply
    event.message.delete
    reply
  end
end
