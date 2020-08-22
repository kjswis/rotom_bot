require './app/app_forms/app_form.rb'

class ItemRejection < ApplicationForm
  def self.process
    @process ||= Application.new('Item Rejection') do |event|
      # Save app and check emote confirmation
      app = event.message.embeds.first
      reactions = event.message.reactions

      if reactions[Emoji::CHECK]&.count.to_i > 1
        # Find user and create embed
        user = event.server.member(UID.match(app.description)[1])
        embed = rejected_app(event, :item)

        # Create responses
        reply = [
          BotResponse.new(destination: event.channel.id, embed: embed, timer: 5),
          BotResponse.new(destination: user.dm.id, embed: embed)
        ]

        # Delete message and reply
        event.message.delete
        reply
      end
    rescue StandardError => e
      error_embed(e.message)
    end
  end
end
