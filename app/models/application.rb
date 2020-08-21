class Application
  attr_reader :name, :operation

  def initialize(name, &block)
    @name = name
    @operation = block
  end

  def call(event)
    operation.call(event)
  end
end
