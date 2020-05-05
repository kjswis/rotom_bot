# frozen_string_literal: true
require_relative 'emoji.rb'

module CharApp
  GRAMMAR = "Please check your grammar and capitalization"
  IMAGE = "Please check your units, grammar, and capitalization"
  LORE = "Your image is inappropriate or conflicts with the age rating"
  NONSENSE = "The character has conflicting personality traits or backstory"
  DUPLICATE = "This character is either very similar to another, or does not have a proper reason to exist"
  OVERPOWERED = "This character has unexplained abilities or is generally too powerful"
  #GRAMMAR = "Please check your grammar and\ncapitalization"
  #IMAGE = "Please check your units,\ngrammar, and capitalization"
  #LORE = "Your image is inappropriate or\nconflicts with the age rating"
  #NONSENSE = "The character has conflicting\npersonality traits or backstory"
  #DUPLICATE = "This character is either very\nsimilar to another, or does\nnot have a proper reason to exist"
  #OVERPOWERED = "This character has unexplained\nabilities or is generally\ntoo powerful"
  INLINE_SPACE = "------------------------------"

  REJECT_MESSAGES = {
    Emoji::SPEECH_BUBBLE => GRAMMAR,
    Emoji::PICTURE => IMAGE,
    Emoji::BOOKS => LORE,
    Emoji::NOTE => DM_NOTES,
    Emoji::QUESTION => NONSENSE,
    Emoji::PEOPLE => DUPLICATE,
    Emoji::WIZARD => OVERPOWERED
  }
end
