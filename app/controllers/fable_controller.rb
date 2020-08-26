class FableController
  def self.edit_fable(params)
    f_hash = Fable.from_form(params)

    fable = Fable.find_by(edit_url: f_hash["edit_url"])
    if fable
      fable.update(f_hash)
      fable.reload
    else
      Fable.create(f_hash)
    end
  end
end
