# frozen_string_literal: true

require_relative '../../../examples/data_gateways/memory/fundraising_event'
require_relative '../../../domain/fundraising_events/use_cases/create_fundraising_event'

require 'debug'

RSpec.describe 'Fundraising event creation' do
  context 'when successful' do
    let(:gateway)         { Memory::FundraisingEvent }
    let(:input)           { { name: 'fundraising name' } }
    let(:expected_output) { { name: 'fundraising name' } }

    it 'creates a new fundraising event' do
      request = CreateFundraisingEvent::Request.new(**input)

      response = CreateFundraisingEvent.new(gateway:).call(request)

      expect(response.to_h).to eq(expected_output)
      expect(gateway._load_last_fundraising_event).to eq(expected_output)
    end
  end
end
