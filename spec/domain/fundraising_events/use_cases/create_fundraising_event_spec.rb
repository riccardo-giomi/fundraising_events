# frozen_string_literal: true

require_relative '../../../../domain/fundraising_events/entities/fundraising_event'
require_relative '../../../../domain/fundraising_events/use_cases/create_fundraising_event'

class ImplementedGateway < DataGateways::FundraisingEvent
  class << self
    def create_fundraising_event(name:)
      { id: 666, name: }
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

    let(:request) do
      CreateFundraisingEvent::Request.new({ name: 'Blood for the blood god' })
    end

    it 'requires a request argument' do
      expect { use_case.call }.to raise_error(ArgumentError)
    end

    it 'requires an argument of a specific type' do
      hash_argument = { name: 'Pastry for the plebs' }

      expect { use_case.call(hash_argument) }.to raise_error(InvalidRequestError)
    end

    it 'requires its argument to be a Request object' do
      expect { use_case.call(request) }.not_to raise_error
    end

    context 'when successful' do
      entity = nil

      before do
        allow(FundraisingEvent).to receive(:new).and_wrap_original do |method, *args, **kwd|
          entity = method.call(*args, **kwd)
          allow(entity).to receive(:create).and_call_original
          entity
        end
        allow(ImplementedGateway).to receive(:create_fundraising_event).and_call_original
      end

      it 'creates entities as required' do
        use_case.call(request)

        expect(FundraisingEvent).to have_received(:new)
          .with({ name: 'Blood for the blood god' })
      end

      it 'uses the required entities to prepare a response' do
        use_case.call(request)

        expect(entity).to have_received(:create)
      end

      it 'uses the data gateway to access data I/O' do
        use_case.call(request)

        expect(ImplementedGateway).to have_received(:create_fundraising_event)
          .with({ name: 'Blood for the blood god' })
      end

      it 'returns a response with expanded fundraising event data' do
        response = use_case.call(request)

        expect(response.to_h).to eq({ id: 666, name: 'Blood for the blood god' })
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
