# frozen_string_literal: true

require_relative '../entities/fundraising_event'
require_relative '../data_gateways/fundraising_event'

module Domain
  class MissingDataGatewayError < StandardError; end
  class InvalidDataGatewayError < StandardError; end

  class InvalidRequestError     < StandardError; end

  class CreateFundraisingEvent
    Request = Struct.new(:name, keyword_init: true)
    Response = Struct.new(:id, :name, keyword_init: true)

    def initialize(gateway: nil)
      @gateway = gateway
      raise MissingDataGatewayError, ':gateway argument required' unless @gateway
      raise InvalidDataGatewayError, ':gateway needs to extend Domain::DataGateways::FundraisingEvent' if invalid_gateway
    end

    def call(request)
      raise InvalidRequestError unless request.is_a? Request

      entity_response  = FundraisingEvent.new(name: request.name).create
      gateway_response = @gateway.create_fundraising_event(**entity_response)

      Response.new(**gateway_response)
    rescue Domain::ValidationError => e
      raise Domain::ValidationError.new(e.message, errors: { fundraising_event: e.errors })
    end

    private

    def invalid_gateway
      gateway = @gateway.is_a?(Class) ? @gateway : @gateway.class
      !gateway.ancestors.include? Domain::DataGateways::FundraisingEvent
    end
  end
end
