require_relative '../handlers/exchange_handler'
module Api
  module Services
    module Exchange
      class Handler
        include ::Api::Services::Handlers::ExchangeHandler

        EURO = "EUR".freeze
        USD = "USD".freeze
        JPY = "JPY".freeze

        def in_euros(date,currency,amount)
          case currency
          when EURO then amount
          when USD,JPY then amount / ::Exchange.rate(date,currency)
          end
        end
      end
    end
  end
end
