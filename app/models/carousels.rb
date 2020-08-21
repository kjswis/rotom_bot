class Carousel < ActiveRecord::Base
  validates :message_id, presence: true

  def navigate(event)
    # Determine what type of carousel this is
    if options
      # User List
      UserCarousel.update_embed(event, self)
    elsif char_id
      # Character
      CharacterCarousel.update_embed(event, self)
    elsif image_id
      # Image
      ImageCarousel.update_embed(event, self)
    elsif landmark_id
      # Landmark
      LandmarkCarousel.update_embed(event, self)
    else
      # Member List
      GuildCarousel.update_embed(event, self)
    end
  rescue StandardError => e
    error_embed(e.message)
  end

  def close(event)
    self.destroy
    event.message.delete
  end
end
