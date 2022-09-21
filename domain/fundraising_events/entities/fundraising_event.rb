# frozen_string_literal: true

require_relative '../../_errors/validation_error'

module Domain
  class FundraisingEvent
    def initialize(id: nil, name:)
      @id   = id
      @name = +name unless name.nil?
    end

    def create
      sanitize_values
      validate_for_creation
      { name: @name }
    end

    private

    def sanitize_values
      @name&.strip!
    end

    def validate_for_creation
      errors = {}
      errors[:id]   = :not_nil if @id
      errors[:name] = :blank   if @name.to_s.empty?

      raise ValidationError.new('invalid fundraising event', errors:) unless errors.empty?
    end
  end
end
