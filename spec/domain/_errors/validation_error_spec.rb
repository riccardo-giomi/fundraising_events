# frozen_string_literal: true

require_relative '../../../domain/_errors/validation_error'

RSpec.describe Domain::ValidationError do
  subject(:validation_error) do
    described_class.new('error message', errors: { example: 'error' })
  end

  context 'when it is created or raised' do
    it 'acts as a Ruby exception' do
      expect(validation_error).to be_a(StandardError)
      expect { raise validation_error }.to raise_error(described_class)
    end

    it 'requires a message' do
      expect { described_class.new(errors: {}) }.to raise_error(ArgumentError)
    end

    it 'requires information on what went wrong' do
      expect { described_class.new('error with no data') }.to raise_error(ArgumentError, /:errors/)
    end
  end

  describe '#errors' do
    it 'provides structured information on what went wrong' do
      expect(validation_error.errors).to eq({ example: 'error' })
    end
  end

  describe '#inspect' do
    it 'also shows the errors hash' do
      expect(validation_error.inspect).to match(/@errors=\{/)
    end
  end
end
