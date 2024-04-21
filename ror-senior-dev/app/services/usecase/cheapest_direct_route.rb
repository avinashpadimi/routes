require_relative './cheapest_route'
module Api
  module Services
    module Usecase
      class CheapestDirectRoute < CheapestRoute
        private
        def routes
          @routes ||= handler.direct_routes(params[:origin],params[:destination])
        end
      end
    end
  end
end
