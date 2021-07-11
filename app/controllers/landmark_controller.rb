class LandmarkController
  def self.edit_landmark(params)
    lm_hash = Landmark.from_form(params)

    if lm = Landmark.find_by(edit_url: lm_hash["edit_url"])
      lm.update(lm_hash)
      lm.reload
    else
      lm = Landmark.create(lm_hash)
    end

    lm
  end

  def self.diff(params)
    return unless old_app = Landmark.find_by(edit_url: params.footer.text)

    new_app = Landmark.new(Landmark.from_form(params))
    Landmark::MAPPING.map{ |k,v| k if old_app[v] != new_app[v] }.reject{ |a| a == nil }
  end
end
