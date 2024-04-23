# frozen_string_literal: true

require_relative '../handlers/exchange_handler'
module Api
  module Services
    module Exchange
      class Handler
        include ::Api::Services::Handlers::ExchangeHandler

        EUR = 'EUR'
        USD = 'USD'
        JPY = 'JPY'

        def in_euros(date, currency, amount)
          value = case currency
                  when EUR then amount
                  when USD, JPY then amount / ::Exchange.rate(date, currency)
                  else
                    amount
                  end
          value.round(3)
        end
      end
    end
  end
end
