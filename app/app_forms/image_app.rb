require './app/app_forms/app_form.rb'

class ImageApplication < ApplicationForm
  def self.process
    @process ||= Application.new('Image Application') do |event|
      # Calculate majority, and check votes
      maj = majority(event)

      reactions = event.message.reactions
      if reactions[Emoji::Y].count.to_i > maj && star(event)
        approve(event)
      elsif reactions[Emoji::N].count.to_i > maj
        deny(event)
      elsif reactions[Emoji::Cross]&.count.to_i > 1
        remove(event)
      end
    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.approve(event)
    # Update image and find character
    image = ImageController.edit_image(app)
    character = Character.find(image.char_id)

    # Determine appropriate channel
    channel = image.rating == 'NSFW' ? ENV['CHAR_NSFW_CH'] : ENV['CHAT_CH']

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
      embed: reject_app_embed(app, :image),
      reactions: ImgApp::REJECT_MESSAGES.map{ |k,v| k }
    )

    # Delete app, and reply
    event.message.delete
    reply
  end
end
