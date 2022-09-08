# frozen_string_literal: true

require_relative '../../../domain/fundraising_events/data_gateways/fundraising_event'

module Memory
  class FundraisingEvent < DataGateways::FundraisingEvent
    @@values = [] # rubocop:disable Style/ClassVars

    class << self
      def create_fundraising_event(name:)
        fundraising_event = { name: }
        @@values << fundraising_event
        fundraising_event
      end

      # cheating a little for testing, this is not (yet?) part of the "public interface"
      def _load_last_fundraising_event
        @@values.last
      end
    end
  end
end
