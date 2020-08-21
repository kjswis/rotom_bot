require_relative '../../lib/emoji.rb'

def section_react(message)
  Emoji::MEMBER.each do |emote|
    message.react(emote)
  end
end

def arrow_react(message)
  message.react(Emoji::UNDO)
  message.react(Emoji::LEFT)
  message.react(Emoji::RIGHT)
  message.react(Emoji::CROSS)
end

def option_react(message, opts)
  opts.each.with_index do |_, i|
    message.react(Emoji::NUMBERS[i])
  end
  message.react(Emoji::CROSS)
end

def landmark_react(message)
  message.react(Emoji::BOOKS)
  message.react(Emoji::SKULL)
  message.react(Emoji::MAP)
  message.react(Emoji::HOUSES)
  message.react(Emoji::PEOPLE)
  message.react(Emoji::CROSS)
end
