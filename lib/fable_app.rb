# frozen_string_literal: true
require_relative 'emoji.rb'

module FableApp
  GRAMMAR = "Please check your grammar and capitalization"
  IMAGE = "The given image doesn't seem relevant, or is inappropriate"
  LORE = "This fable conflicts with server lore"
  ELABORATE = "This fable is too short or does not provide useful lore"
  NONSENSE = "The keywords are confusing or unrelated"
  DUPLICATE = "This fable is either very similar to another, or does not add any new lore"
  UNDERLEVELED = "You are not high enough level to make this fable"
  DISCUSSED = "You have already discussed issues with an admin"
  INLINE_SPACE = "------------------------------"

  REJECT_MESSAGES = {
    Emoji::SPEECH_BUBBLE => GRAMMAR,
    Emoji::PICTURE => IMAGE,
    Emoji::BOOKS => LORE,
    Emoji::NOTE => ELABORATE,
    Emoji::QUESTION => NONSENSE,
    Emoji::PEOPLE => DUPLICATE,
    Emoji::WIZARD => UNDERLEVELED,
    Emoji::TALK => DISCUSSED
  }
end
