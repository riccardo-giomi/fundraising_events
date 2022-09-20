# frozen_string_literal: true

require_relative '../../../../domain/fundraising_events/data_gateways/fundraising_event'

class UnimplementedGateway < Domain::DataGateways::FundraisingEvent; end

RSpec.describe Domain::DataGateways::FundraisingEvent do
  describe 'provides abstract methods to implement' do
    it 'provides ::create_fundraising_event' do
      expect { UnimplementedGateway.create_fundraising_event(name: 'name') }
        .to raise_error Domain::DataGateways::MethodNotImplementedError, /abstract/
    end
  end

  # These methods should always be private (use with #send), and start with an underscore
  describe 'provides abstract "cheats" to help testing' do
    it 'provides ::_reset that should clear the data among examples' do
      expect { UnimplementedGateway.send(:_reset) }
        .to raise_error Domain::DataGateways::MethodNotImplementedError, /abstract/
    end

    it 'provides ::_count_fundraising_events that should return the count of data "records"' do
      expect { UnimplementedGateway.send(:_count_fundraising_events) }
        .to raise_error Domain::DataGateways::MethodNotImplementedError, /abstract/
    end
  end
end
