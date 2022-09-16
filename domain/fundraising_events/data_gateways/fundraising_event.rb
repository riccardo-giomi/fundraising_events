# frozen_string_literal: true

module DataGateways
  class MethodNotImplementedError < StandardError; end

  class FundraisingEvent
    class << self
      # abstract
      def create_fundraising_event(name:)
        raise MethodNotImplementedError, "Hi, I'm an abstract method, please implement me"
      end

      private

      # Cheats to make testing easier
      def _count_fundraising_events
        raise_not_implemented
      end

      def _reset
        raise_not_implemented
      end

      def raise_not_implemented
        raise MethodNotImplementedError, "Hi, I'm an abstract method, please implement me"
      end
    end
  end
end
