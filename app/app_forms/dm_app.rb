require './app/app_forms/app_form.rb'

class NewApplication < ApplicationForm
  def self.process
    @process ||= Application.new('New App') do |event|
      # Check Reactions
      reactions = event.message.reactions
      if reactions[Emoji::PHONE]&.count.to_i > 1
        # Dump the user's key in the dm
        event.author.id.to_s
      end
    end
  end
end
