# frozen_string_literal: true

module Api
  module Services
    module Handlers
      module RouteHandler
        def routes
          raise_error
        end

        def direct_routes(_origin, _destination)
          raise_error
        end

        def cheapest_route(_routes)
          raise_error
        end

        def raise_error
          raise NotImplementedError, "#{self.class} has not implemented method #{__method__}"
        end
      end
    end
  end
end
