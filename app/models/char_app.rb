# frozen_string_literal: true
require_relative '../../lib/emoji.rb'

module CharApp
  GRAMMAR = "Please check your grammar and\ncapitalization"
  UNITS = "Please specify your units in\nImperial or Metric"
  IMAGE = "Your image is inappropriate for\ndefault use"
  LORE = "One or more responses are\nconflicting with server lore"
  UNDER_AGE = "Your age conflicts with the\nspecified rating"
  INVALID = "One or more responses are\ninvalid"
  VULGAR = "Your application is too vulgar,\nor conflicts with server rules"
  DM_NOTES = "Please elaborate on your\nDM Notes"
  INLINE_SPACE = "------------------------------------"

  REJECT_MESSAGES = {
    Emoji::SPEECH_BUBBLE => GRAMMAR,
    Emoji::SCALE => UNITS,
    Emoji::PICTURE => IMAGE,
    Emoji::BOOKS => LORE,
    Emoji::BABY => UNDER_AGE,
    Emoji::SKULL => INVALID,
    Emoji::VULGAR => VULGAR,
    Emoji::NOTE => DM_NOTES
  }
end
