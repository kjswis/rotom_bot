class BaseCommand
  def self.name
    cmd.name
  end

  def self.call(*args)
    cmd.call(*args)
  end

  def self.cmd
    raise 'NYI'
  end

  def self.restricted_to
    nil
  end

  def self.example_command(event=nil)
    nil
  end

  def self.admin_opts
    nil
  end
end
