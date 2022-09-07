# frozen_string_literal: true

class ValidationError < StandardError; end

class FundraisingEvent
  def initialize(name:)
    @name = name
  end

  def create
    validate_for_creation
    { name: @name }
  end

  private

  def validate_for_creation
    raise(ValidationError, 'name: blank') if @name.to_s.gsub(/\s/, '').empty?
  end
end
