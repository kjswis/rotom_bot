# frozen_string_literal: true
require_relative '../../lib/emoji.rb'

module ImgApp
  SPECIES = "Your image contradicts your\ncharacters species"
  KEYWORD = "Your keyword is invalid or\nmisleading"
  CATEGORY = "Your image category is\nincorrectly flagged"
  URL = "Your image url is incorrect,\nplease check for the `.png` etc.."
  LORE = "Your image is conflicting\nwith server lore"
  VULGAR = "Your image or keyword is too\nvulgar, or contradicts server rules"
  INLINE_SPACE = "------------------------------------"

  REJECT_MESSAGES = {
    Emoji::DOG => SPECIES,
    Emoji::KEY => KEYWORD,
    Emoji::FLAG => CATEGORY,
    Emoji::PAGE => URL,
    Emoji::BOOKS => LORE,
    Emoji::VULGAR => VULGAR
  }
end

