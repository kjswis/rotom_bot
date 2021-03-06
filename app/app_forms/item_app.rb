require './app/app_forms/app_form.rb'

class ItemApplication < ApplicationForm
  def self.process
    @process ||= Application.new('Item Application') do |event|
      # Calculate majority
      maj = majority(event)
      check_votes(event, maj)

    rescue StandardError => e
      error_embed(e.message)
    end
  end

  def self.approve(event)
    # Save the application
    app = event.message.embeds.first

    # Save item
    item = ItemController.edit_landmark(app)
    reply = BotResponse.new(
      destination: ENV['LAND_CHANNEL'],
      text: "Good News, <@#{item.user_id}>! Your landmark was approved!",
      embed: item_embed(item, event)
    )

    event.message.delete
    reply
  end

  def self.deny(event)
    reply = BotResponse.new(
      embed: reject_app(event.message.embeds.first, :item),
      reactions: ItemApp::REJECT_MESSAGES.map{ |k,v| k }.push(Emoji::CHECK)
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
      embed: self_edit_embed(app.footer.text, Url::ITEM),
      timer: 35
    )

    # Delete app and reply
    event.message.delete
    reply
  end
end
