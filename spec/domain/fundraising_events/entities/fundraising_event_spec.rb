# frozen_string_literal: true

# fundraising_event_spec.rb

require_relative '../../../../domain/fundraising_events/entities/fundraising_event'

RSpec.describe Domain::FundraisingEvent do
  describe '::new' do
    it 'requires attributes for the event' do
      expect { described_class.new }.to raise_error(ArgumentError, /:name/)
    end
  end

  describe '#create' do
    it 'checks that an id is not present' do
      entity = described_class.new(id: 1, name: 'Blood for the blood god')

      expect { entity.create }.to raise_error do |error|
        expect(error).to be_a(Domain::ValidationError)
        expect(error.message).to match(/invalid/)
        expect(error.errors).to eq({ id: :not_nil })
      end
    end

    it "checks that there's a name" do
      entity = described_class.new(name: '')

      expect { entity.create }.to raise_error do |error|
        expect(error).to be_a(Domain::ValidationError)
        expect(error.message).to match(/invalid/)
        expect(error.errors).to eq({ name: :blank })
      end
    end

    it 'is not fooled if the name contains spaces' do
      entity = described_class.new(name: '   ')

      expect { entity.create }.to raise_error(Domain::ValidationError, /invalid/)
    end

    describe 'return data' do
      it 'is ready for I/O save operations' do
        valid_data = { name: 'Skulls for the skull throne' }

        data = described_class.new(**valid_data).create

        expect(data).to eq valid_data
      end

      it 'still contains no id' do
        valid_data = { name: 'Skulls for the skull throne' }

        data = described_class.new(**valid_data).create

        expect(data[:id]).to be_empty.or be_nil
      end

      it 'is sanitized as required' do
        valid_data = { name: " spaaaaaace(s) \t " }

        data = described_class.new(**valid_data).create

        expect(data[:name]).to eq('spaaaaaace(s)')
      end
    end
  end
end
