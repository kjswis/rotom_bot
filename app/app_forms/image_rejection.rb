class ImageRejection < ApplicationForm
  def self.process
    @process ||= Application.new('Image Rejection') do |event|
      # Save app and check emote confirmation
      app = event.message.embeds.first
      reactions = event.message.reactions

      if reactions[Emoji::CHECK].count.to_i > 1
        # Find user and create embed
        user = event.server.member(UID.match(app.description)[1])
        embed = rejected_app(event, :image)

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
      admin_error_embed(e.message)
    end
  end
end
