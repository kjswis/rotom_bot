require_relative '../../lib/emoji.rb'

def section_react(message)
  Emoji::CAROUSEL.each do |emote|
    message.react(emote)
  end
end

def arrow_react(message)
  message.react(Emoji::UNDO)
  message.react(Emoji::LEFT)
  message.react(Emoji::RIGHT)
  message.react(Emoji::CROSS)
end
