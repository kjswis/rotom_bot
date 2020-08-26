require './app/app_forms/app_form.rb'

class FableApplication < ApplicationForm
  def self.process
    @process||= Application.new('Fable Application') do |event|
      # Calculate majority
      maj = majority(event)

      # Check votes
      reactions = event.message.reactions
      if reactions[Emoji::Y]&.count.to_i > maj && star(event)
        approve(event)
      elsif reactions[Emoji::N]&.count.to_i > maj
        deny(event)
      elsif reactions[Emoji::CRAYON]&.count.to_i > 1
        edit(event)
      elsif reactions[Emoji::CROSS]&.count.to_i > 1
        remove(event)
      end
    end
  end

  def self.approve(event)
    # Save the application
    app = event.message.embeds.first

    # Save fable
    fable = FableController.edit_fable(app)
    reply = BotResponse.new(
      destination: ENV['FABLE_CH'],
      text: "Good News, <@#{fable.user_id}>! Your fable was published!",
      embed: fable_embed(fable, event)
    )

    event.message.delete
    reply
  end

  def self.deny(event)
    reply = BotResponse.new(
      embed: reject_app(event.message.embeds.first, :fable),
      reactions: FableApp::REJECT_MESSAGES.map{ |k,v| k }.push(Emoji::CHECK)
    )

    # Delete message and reply
    event.message.delete
    reply
  end

  def self.edit(event)
    # Save the application
    app = event.message.embeds.first

    reply = BotResponse.new(
      destination: event.channel.id,
      embed: self_edit_embed(app.footer.text, Url::FABLE),
      timer: 35
    )

    # Delete app and reply
    event.message.delete
    reply
  end
end
