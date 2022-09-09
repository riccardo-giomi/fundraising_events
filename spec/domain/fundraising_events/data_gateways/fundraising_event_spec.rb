# frozen_string_literal: true

require_relative '../../../../domain/fundraising_events/data_gateways/fundraising_event'

class UnimplementedGateway < DataGateways::FundraisingEvent; end

RSpec.describe DataGateways::FundraisingEvent do
  describe 'provides abstract methods to implement' do
    it 'provides ::create_fundraising_event' do
      expect { UnimplementedGateway.create_fundraising_event(name: 'name') }
        .to raise_error DataGateways::MethodNotImplementedError, /abstract/
    end
  end
end
