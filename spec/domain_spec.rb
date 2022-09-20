# frozen_string_literal: true

require_relative '../domain'
require_relative '../examples/data_gateways/memory/fundraising_event'

RSpec.describe Domain::FundraisingEvents do
  describe 'configuration' do
    before do
      described_class.data_gateway = nil
    end

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

  describe 'exposes classes that need to be known outside the module' do
    describe 'Domain::FundraisingEvents::CreateRequest' do
      it 'is a renamed copy of Domain::CreateFundraisingEvent::Request' do
        expect(Domain::FundraisingEvents::CreateRequest.ancestors)
          .to include(Domain::CreateFundraisingEvent::Request)
      end
    end

    describe 'Domain::FundraisingEvents::CreateResponse' do
      it 'is a renamed copy of Domain::CreateFundraisingEvent::Response' do
        expect(Domain::FundraisingEvents::CreateResponse.ancestors)
          .to include(Domain::CreateFundraisingEvent::Response)
      end
    end
  end

  context 'when creating a new fundraising event' do
    describe '::create' do
      before do
        described_class.data_gateway = Memory::FundraisingEvent
      end

      it 'gives access to the CreateFundraisingEvent use case' do
        request = Domain::FundraisingEvents::CreateRequest.new(name: 'name')

        response = described_class.create(request)

        expect(response).to be_a(Domain::FundraisingEvents::CreateResponse)
      end
    end
  end
end
