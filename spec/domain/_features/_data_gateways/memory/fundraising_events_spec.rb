# frozen_string_literal: true

require_relative '../../../../../examples/data_gateways/memory/fundraising_event'

# TODO: refactor and create an example group for data gateways
RSpec.describe Memory::FundraisingEvent do
  before do
    described_class.send(:_reset)
  end

  describe '#create_fundraising_event' do
    describe 'in its arguments' do
      it 'requires a name' do
        expect { described_class.create_fundraising_event }.to raise_error(ArgumentError, /:name/)
      end
    end
  end

  context 'when successful' do
    let(:result) do
      described_class.create_fundraising_event(name: "Fundraising event's name")
    end

    it 'returns a simple hash' do
      expect(result).to be_a(Hash)
    end

    it 'returns the data saved' do
      expect(result[:name]).to eq("Fundraising event's name")
    end

    it 'returns an id to identify the persisted data "record"' do
      expect(result[:id]).to be_a(Integer).and(be > 0)
    end

    it 'adds an element to the persisted data' do
      expect do
        described_class.create_fundraising_event(name: "Fundraising event's name")
      end.to change { described_class.send(:_count_fundraising_events) }.from(0).to(1)
    end
  end

  context 'if testing it allows to cheat:' do
    describe '::_count_fundraising_events' do
      it 'provides an ugly way to count all the persisted results' do
        expect(described_class.send(:_count_fundraising_events)).to be_zero

        10.times do |n|
          described_class.create_fundraising_event(name: "fundraising event #{n}")
        end

        expect(described_class.send(:_count_fundraising_events)).to eq 10
      end
    end

    describe '::_reset' do
      it 'provides an ugly way to reset the persisted data' do
        10.times do |n|
          described_class.create_fundraising_event(name: "fundraising event #{n}")
        end

        expect { described_class.send(:_reset) }
          .to change { described_class.send(:_count_fundraising_events) }
          .from(10).to(0)
      end
    end
  end
end
