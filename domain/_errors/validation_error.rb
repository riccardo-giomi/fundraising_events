# frozen_string_literal: true

module Domain
  class ValidationError < StandardError
    attr_accessor :errors

    def initialize(message, errors:)
      @errors = errors
      super(message)
    end

    def inspect
      "#<ValidationError: #{message} @errors=#{@errors.inspect}>"
    end
  end
end
