# frozen_string_literal: true

module Serializable
  extend ActiveSupport::Concern

  def initialize(json)
    unless json.blank?
      json = JSON.parse(json) if json.is_a?(String)
      json.to_hash.each do |k, v|
        klass = self.class.constants.detect { |c| c.downcase == k.to_sym }
        v = self.class.const_get(klass).new(v) if klass

        public_send("#{k}=", v)
      end
    end
  end

  class_methods do
    def load(json)
      return nil if json.blank?

      new(json)
    end

    def dump(obj)
      # Make sure the type is right.
      if obj.is_a?(self)
        obj.to_json
      else
        raise "Expected #{self}, got #{obj.class}"
      end
    end
  end
end
