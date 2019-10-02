require 'optparse'

class Command
  attr_reader :name, :operation

  def initialize(name, description, options =[], &block)
    @name = name
    @description = description
    @options = options
    @operation = block
  end

  def description
    @description
  end

  def options
    @options
  end

  def call(message_str, event=nil)
    match = /pkmn-\w+\s?(.*)/.match(message_str)
    args = match[1]
    params = args.split(/\s?\|\s?/).reject(&:empty?)

    operation.call(event, *params)
  end
end
