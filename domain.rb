# frozen_string_literal: true

require_relative 'domain/fundraising_events/use_cases/create_fundraising_event'

module Domain
  class FundraisingEvents
    class DataGateway < DataGateways::FundraisingEvent; end

    class CreateRequest < CreateFundraisingEvent::Request; end
    class CreateResponse < CreateFundraisingEvent::Response; end

    class << self
      attr_writer :data_gateway

      def configure
        yield self
      end

      def data_gateway
        @data_gateway || raise(MissingDataGatewayError, 'Missing data gateway')
      end

      def create(request)
        response = CreateFundraisingEvent.new(gateway: data_gateway).call(request)
        CreateResponse.new(**response.to_h)
      end
    end
  end
end
