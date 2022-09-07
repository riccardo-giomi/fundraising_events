# frozen_string_literal: true

module DataGateways
  class MethodNotImplementedError < StandardError; end

  class FundraisingEvent
    class << self
#     # abstract
#     def create_fundraising_event(name:)
#       raise MethodNotImplementedError("Hi, I'm an abstract method, please implement me")
#     end
    end
  end
end
