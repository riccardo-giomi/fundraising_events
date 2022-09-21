# frozen_string_literal: true

require_relative '../../../examples/data_gateways/memory/fundraising_event'
require_relative '../../../domain/fundraising_events/use_cases/create_fundraising_event'

RSpec.describe 'Fundraising event creation' do
  let(:gateway) { Memory::FundraisingEvent }

  context 'when successful' do
    let(:request) { Domain::CreateFundraisingEvent::Request.new(name: 'fundraising name') }

    before do
      gateway.send(:_reset)
    end

    it 'creates a new fundraising event' do
      response = Domain::CreateFundraisingEvent.new(gateway:).call(request)
      output = response.to_h

      expect(output[:id]).to be_a(Integer).and(be > 0)
      expect(output[:name]).to eq('fundraising name')
    end

    it 'actually persists data somewhere' do
      expect do
        Domain::CreateFundraisingEvent.new(gateway:).call(request)
      end.to change { gateway.send(:_count_fundraising_events) }.from(0).to(1)
    end
  end

  context 'when not successful' do
    let(:invalid_request) { Domain::CreateFundraisingEvent::Request.new(name: '') }

    it 'raises an ValidationError with the correct message and data' do
      expected_errors = { fundraising_event: { name: :blank } }

      expect { Domain::CreateFundraisingEvent.new(gateway:).call(invalid_request) }
        .to raise_error do |error|
          expect(error).to be_a(Domain::ValidationError)
          expect(error.message).to match(/invalid/)
          expect(error.errors).to eq(expected_errors)
        end
    end
  end
end
