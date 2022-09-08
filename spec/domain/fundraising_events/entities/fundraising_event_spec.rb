# frozen_string_literal: true

# fundraising_event_spec.rb

require_relative '../../../../domain/fundraising_events/entities/fundraising_event'

RSpec.describe FundraisingEvent do
  describe '::new' do
    it 'requires attributes for the event' do
      expect { described_class.new }.to raise_error(ArgumentError, /:name/)
    end
  end

  describe '#create' do
    it "checks that there's a name" do
      entity = described_class.new(name: nil)

      expect { entity.create }.to raise_error(ValidationError, /blank/)
    end

    it 'is not fooled if the name contains spaces' do
      entity = described_class.new(name: '   ')

      expect { entity.create }.to raise_error(ValidationError, /blank/)
    end

    it 'returns data ready for I/O save operations' do
      valid_data = { name: 'Skulls for the skull throne' }

      entity = described_class.new(**valid_data)

      expect(entity.create).to eq valid_data
    end
  end
end
