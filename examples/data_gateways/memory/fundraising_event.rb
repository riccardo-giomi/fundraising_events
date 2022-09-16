# frozen_string_literal: true

require_relative '../../../domain/fundraising_events/data_gateways/fundraising_event'

module Memory
  class FundraisingEvent < DataGateways::FundraisingEvent
    @@next_id = 1
    @@values = []

    class << self
      def create_fundraising_event(name:)
        fundraising_event = { id: new_id, name: }
        @@values << fundraising_event
        fundraising_event
      end

      private

      def new_id
        id = @@next_id
        @@next_id += 1
        id
      end

      # Test support methods
      def _count_fundraising_events
        @@values.count
      end

      def _reset
        @@values = []
        @@next_id = 1
      end
    end
  end
end
