# frozen_string_literal: true

class ValidationError < StandardError; end

class FundraisingEvent
  def initialize(id: nil, name:)
    @id   = id
    @name = name
  end

  def create
    validate_for_creation
    { name: @name }
  end

  private

  def validate_for_creation
    raise(ValidationError, 'id: this entity already has an id') if @id
    raise(ValidationError, 'name: blank') if @name.to_s.gsub(/\s/, '').empty?
  end
end
