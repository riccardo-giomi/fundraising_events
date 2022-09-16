# frozen_string_literal: true

require_relative '../../../examples/data_gateways/memory/fundraising_event'
require_relative '../../../domain/fundraising_events/use_cases/create_fundraising_event'

RSpec.describe 'Fundraising event creation' do
  context 'when successful' do
    let(:gateway) { Memory::FundraisingEvent }
    let(:request) { CreateFundraisingEvent::Request.new(name: 'fundraising name') }

    before do
      gateway.send(:_reset)
    end

    it 'creates a new fundraising event' do
      response = CreateFundraisingEvent.new(gateway:).call(request)
      output = response.to_h

      expect(output[:id]).to be_a(Integer).and(be > 0)
      expect(output[:name]).to eq('fundraising name')
    end

    it 'actually persists data somewhere' do
      expect do
        CreateFundraisingEvent.new(gateway:).call(request)
      end.to change { gateway.send(:_count_fundraising_events) }.from(0).to(1)
    end
  end
end
