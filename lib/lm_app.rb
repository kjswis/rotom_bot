# frozen_string_literal: true
require_relative 'emoji.rb'

module LmApp
  GRAMMAR = "Please check your grammar and capitalization"
  IMAGE = "Please include an image for your landmark"
  LORE = "This landmark conflicts with server lore"
  ELABORATE = "This landmark is too sparce or does not have enough of a public use"
  NONSENSE = "The sections are filled out incorrectly"
  DUPLICATE = "This landmark is either very similar to another, or does not have a proper reason to exist"
  UNDERLEVELED = "You are not high enough level to make this landmark"
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
