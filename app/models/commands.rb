require 'optparse'

class Command
  attr_reader :name, :options_parser, :operation

  def initialize(name, options ={}, &block)
    @name = name
    @operation = block
  end

  def call(message_str, event=nil)
    match = /pkmn-\w+\s?(.*)/.match(message_str)
    args = match[1]
    params = args.split(/\s?\|\s?/).reject(&:empty?)

    operation.call(event, *params)
  end
end
