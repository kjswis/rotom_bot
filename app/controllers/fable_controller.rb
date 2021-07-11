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

  def self.diff(params)
    return unless old_app = Fable.find_by(edit_url: params.footer.text)

    new_app = Fable.new(Fable.from_form(params))
    Fable::MAPPING.map{ |k,v| k if old_app[v] != new_app[v] }.reject{ |a| a == nil }
  end
end
