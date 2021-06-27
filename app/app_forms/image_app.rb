require './app/app_forms/app_form.rb'

class ImageApplication < ApplicationForm
  def self.process
    @process ||= Application.new('Image Application') do |event|
      # Calculate majority
      maj = majority(event)
      check_votes(event, maj)

    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.approve(event)
    # Save app
    app = event.message.embeds.first

    # Update image and find character
    image = ImageController.edit_image(app)
    character = Character.find(image.char_id)

    # Determine appropriate channel
    channel = image.category == 'NSFW' ? ENV['NSFW_CHANNEL'] : ENV['CHAR_CHANNEL']

    reply = BotResponse.new(
      destination: channel,
      text: "Good News, <@#{character.user_id}>! Your image was approved!",
      embed: character_embed(
        character: character,
        event: event,
        section: 'image',
        image: image
      )
    )

    # Delete app and reply
    event.message.delete
    reply
  end

  def self.deny(event)
    # Create App Rejection
    reply = BotResponse.new(
      embed: reject_app(event.message.embeds.first, :image),
      reactions: ImgApp::REJECT_MESSAGES.map{ |k,v| k }.push(Emoji::CHECK)
    )

    # Delete app, and reply
    event.message.delete
    reply
  end
end
