require_relative '../../lib/emoji.rb'

def approval_react(event)
  event.message.react(Emoji::Y)
  event.message.react(Emoji::N)
  event.message.react(Emoji::CRAYON)
  event.message.react(Emoji::CROSS)
end

def too_many(event, user, edit_url, model)
  message = "You have too many #{model}!" +
    "\nPlease deactivate and try again #{Url::CHARACTER}#{edit_url}"

  event.server.member(user).dm(message)
  event.respond(message)
  event.message.delete
end

def unknown_member(event)
  event.message.react(Emoji::WHAT)
  event.message.react(Emoji::CROSS)
end
