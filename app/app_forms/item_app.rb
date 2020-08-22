require './app/app_forms/app_form.rb'

class ItemApplication < ApplicationForm
  def self.process
    @process ||= Application.new('Item Application') do |event|
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
      destination: ENV['LM_CH'],
      text: "Good News, <@#{item.user_id}>! Your landmark was approved!",
      embed: item_embed(item, event)
    )

    event.message.delete
    reply
  end

  def self.deny(event)
    reply = BotResponse.new(
      embed: reject_app(event.message.embeds.first, :item),
      reactions: ItemApp::REJECT_MESSAGES.map{ |k,v| k }
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
