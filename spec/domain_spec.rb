# frozen_string_literal: true

require_relative '../domain'
require_relative '../examples/data_gateways/memory/fundraising_event'

RSpec.describe Domain::FundraisingEvents do
  before do
    described_class.data_gateway = nil
  end

  describe 'configuration' do
    it 'requires a data gateway' do
      expect { described_class.data_gateway }.to raise_error(Domain::MissingDataGatewayError)
    end

    it 'allows to set the data gateway with ::data_gateway=' do
      described_class.data_gateway = Memory::FundraisingEvent

      expect { described_class.data_gateway }.not_to raise_error
    end

    it 'allows to set the configuration in a block with ::configure' do
      described_class.configure do |config|
        config.data_gateway = Memory::FundraisingEvent
      end

      expect { described_class.data_gateway }.not_to raise_error
    end
  end

  context 'when creating a new fundraising event' do
    # describe Domain::FundraisingEvents::CreateRequest do
    #   it ''
    # end

    describe '::create' do
      let(:use_case) { instance_double(Domain::CreateFundraisingEvent) }

      before do
        described_class.data_gateway = Memory::FundraisingEvent

        allow(Domain::CreateFundraisingEvent).to receive(:new)
          .and_return(use_case)
      end

      it 'gives access to the CreateFundraisingEvent use case' do
        allow(use_case).to receive(:call)

        described_class.create(name: 'name')

        expect(Domain::CreateFundraisingEvent).to have_received(:new).with(gateway: Memory::FundraisingEvent)
        expect(use_case).to have_received(:call).with(anything)
      end

      it 'returns a Domain::FundraisingEvents::CreateResponse for namespace convenience' do
        allow(use_case).to receive(:call)
          .and_return(Domain::CreateFundraisingEvent::Response.new({ name: 'name' }))

        expect(described_class.create(name: 'name')).to be_a(Domain::FundraisingEvents::CreateResponse)
      end
    end
  end
end
