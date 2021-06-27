require './app/app_forms/app_form.rb'

class FableApplication < ApplicationForm
  def self.process
    @process||= Application.new('Fable Application') do |event|
      # Calculate majority, and check votes
      maj = majority(event)
      check_votes(event, maj)

    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.approve(event)
    # Save the application
    app = event.message.embeds.first

    # Save fable
    fable = FableController.edit_fable(app)
    reply = BotResponse.new(
      destination: ENV['FABL_CHANNEL'],
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
