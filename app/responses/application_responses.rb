require_relative '../../lib/emoji.rb'

def approval_react(event)
  event.message.react(Emoji::Y)
  event.message.react(Emoji::N)
end

def too_many(event, user, edit_url, model)
  message = "You have too many #{model}!" +
    "\nPlease deactivate and try again #{Url::CHARACTER}#{edit_url[1]}"

  event.server.member(user).dm(message)
  event.message.delete
end

def unknown_member(event)
  content = event.message.content
  content += "\n\n **_I DONT KNOW THIS APPLICANT_**"

  event.message.delete
  event.respond(content)
end
