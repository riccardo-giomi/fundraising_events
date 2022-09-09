# frozen_string_literal: true

require_relative '../../../../domain/fundraising_events/entities/fundraising_event'
require_relative '../../../../domain/fundraising_events/use_cases/create_fundraising_event'

class ImplementedGateway < DataGateways::FundraisingEvent
  class << self
    def create_fundraising_event(name:)
      { name: }
    end
  end
end

RSpec.describe CreateFundraisingEvent do
  describe '::new' do
    describe ':gateway argument' do
      it 'is required' do
        expect { described_class.new }
          .to raise_error(MissingDataGatewayError)
      end

      it 'needs to implement a data gateway "interface"' do
        expect { described_class.new(gateway: Object.new) }.to raise_error(InvalidDataGatewayError)
      end
    end
  end

  describe '#call' do
    subject(:use_case) { described_class.new(gateway: ImplementedGateway) }

    let(:request)      { CreateFundraisingEvent::Request.new(**request_data) }
    let(:request_data) { { name: 'Blood for the blood god' } }

    it 'requires a request argument' do
      expect { use_case.call }.to raise_error(ArgumentError)
    end

    it 'requires an argument (request)' do
      hash_argument = { name: 'Pastry for the plebs' }

      expect { use_case.call(hash_argument) }.to raise_error(InvalidRequestError)
    end

    it 'requires its argument to be of the correct type' do
      expect { use_case.call(request) }.not_to raise_error
    end

    context 'when successful' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:expected_entity_response)   { request_data }
      let(:expected_gateway_response)  { request_data }
      let(:expected_response_data)     { request_data }

      let(:entity)            { instance_double(FundraisingEvent) }
      let(:expected_response) { CreateFundraisingEvent::Response.new(**expected_response_data) }

      before do
        allow(FundraisingEvent).to receive(:new)
          .and_return(entity)

        allow(entity).to receive(:create)
          .and_return(expected_entity_response)

        allow(ImplementedGateway).to receive(:create_fundraising_event)
          .and_return(expected_gateway_response)
      end

      it 'creates entities as required' do
        use_case.call(request)

        expect(FundraisingEvent).to have_received(:new)
          .with(request_data)
      end

      it 'uses the required entities to prepare a response' do
        use_case.call(request)

        expect(entity).to have_received(:create)
      end

      it 'uses the data gateway to access data I/O' do
        use_case.call(request)

        expect(ImplementedGateway).to have_received(:create_fundraising_event)
          .with(request_data)
      end

      it 'returns a response with expanded fundraising event data' do
        response = use_case.call(request)

        expect(response).to eq(expected_response)
      end
    end

    context 'when not successful' do
      let(:invalid_request) { CreateFundraisingEvent::Request.new(name: '') }

      it 'raises an error' do
        expect { use_case.call(invalid_request) }.to raise_error(ValidationError, /name.*blank/)
      end
    end
  end
end
