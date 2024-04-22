# frozen_string_literal: true

module Api
  module Services
    module Handlers
      module ExchangeHandler
        def in_euros(_date, _currency, _amount)
          raise_error
        end

        def raise_error
          raise NotImplementedError, "#{self.class} has not implemented method #{__method__}"
        end
      end
    end
  end
end
