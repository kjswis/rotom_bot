class ApplicationController
  def self.diff(app)
    # find the appropriate app, if exists
    case app.author.name
    when /Character Application/
      CharacterController.diff(app)
    when /Fable Application/
      FableController.diff(app)
    when /Item Application/
      ItemController.diff(app)
    when /Landmark Application/
      LandmarkController.diff(app)
    end
  end
end
