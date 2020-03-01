class LandmarkController
  def self.edit_landmark(params)
    lm_hash = Landmark.from_form(params)

    if lm = Landmark.find_by(edit_url: lm_hash["edit_url"])
      lm.update!(lm_hash)
      lm.reload
    else
      lm = Landmark.create(lm_hash)
    end

    lm
  end
end
