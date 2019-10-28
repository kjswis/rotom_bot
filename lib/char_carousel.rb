# frozen_string_literal: true
require_relative 'emoji.rb'

module CharCarousel
  BIO = "Bio"
  STATUS = "Status"
  TYPE = "Type"
  RUMORS = "Rumors"
  IMAGE = "Images"
  BAGS = "Inventory"
  FAMILY = "Family Tree"
  ALL = "All"
  DEFAULT = "This Key"
  CROSS = "Delete Message"

  REACTIONS = {
    Emoji::NOTEBOOK => BIO,
    Emoji::QUESTION => STATUS,
    Emoji::PALLET => TYPE,
    Emoji::EAR => RUMORS,
    Emoji::PICTURE => IMAGE,
    Emoji::BAGS => BAGS,
    Emoji::FAMILY => FAMILY,
    Emoji::EYES => ALL,
    Emoji::KEY => DEFAULT,
    Emoji::CROSS => CROSS
  }
end
