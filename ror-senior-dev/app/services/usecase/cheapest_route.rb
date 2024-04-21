require_relative "./base"
module Api
  module Services
    module Usecase
      class CheapestRoute < Base
        private

        def call
          handler.cheapest_route(routes) do |date,currency,amount|
            exchange_handler.in_euros(date,currency,amount)
          end
        end

        def routes
          @routes ||= handler.routes(params[:origin],params[:destination])
        end
      end
    end
  end
end
