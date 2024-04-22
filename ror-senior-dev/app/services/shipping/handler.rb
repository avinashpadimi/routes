# frozen_string_literal: true

require_relative '../handlers/route_handler'
module Api
  module Services
    module Shipping
      class Handler
        include ::Api::Services::Handlers::RouteHandler
        def all_routes
          ShippingRoute.routes || []
        end

        def direct_routes(origin, destination)
          all_routes.select { |route| route.origin == origin && route.destination == destination }
        end

        def routes(origin, destination)
          routes_group_by_origin = all_routes
            .select { |route| route.origin != destination && route.destination != origin }
            .group_by(&:origin)
          route_traversal(routes_group_by_origin, origin, destination, [], [])
        end

        def cheapest_route(routes, &block)
          routes.min_by { |route| accumulate_rate(route, &block) }
        end

        private

        def accumulate_rate(routes, &block)
          [routes]
            .flatten
            .sum do |route|
              return Float::INFINITY if route.shipping_rate.nil?

              amount = route.shipping_rate.rate.to_f
              amount = block.call(route.dep_date, route.shipping_rate.currency, amount) if block_given?
              amount
            end
        end

        def route_traversal(routes_hash, origin, destination, final_paths, previous_path)
          (routes_hash[origin] || [])
            .select { |route| previous_path.empty? || (previous_path.last.arr_date < route.dep_date) }
            .each do |route|
              if route.destination == destination
                final_paths << previous_path + [route]
              else
                route_traversal(routes_hash, route.destination, destination, final_paths, previous_path + [route])
              end
            end
          final_paths
        end
      end
    end
  end
end
