require_relative '../handlers/route_handler'
module Api
  module Services
    module Shipping
      class Handler
        include ::Api::Services::Handlers::RouteHandler
        def all_routes
          ShippingRoute.routes
        end

        def direct_routes(origin, destination)
          all_routes.select{ |route| route.origin == origin && route.destination == destination }
        end

        def routes(origin,destination)
          filtered_routes = all_routes.select do |route| 
            route.origin != destination && 
              route.destination != origin
          end
          route_traversal(filtered_routes, origin,destination, [],[])
        end

        def cheapest_route routes, &block
          routes.min_by { |route| accumulate_rate(route, &block) }
        end

        private

        def accumulate_rate routes, &block
          [routes]
            .flatten
            .sum do |route|
              return Float::INFINITY if route.shipping_rate.nil?

              amount = route.shipping_rate.rate.to_i 
              if block_given?
                amount = block.call(route.dep_date, route.shipping_rate.currency, amount)
              end
              amount
            end
        end

        def route_traversal(routes,origin,destination,final_paths,previous_path)
          routes
            .select { |route| route.origin == origin }
            .select { |route| previous_path.empty? || (previous_path.last.arr_date < route.dep_date) }
            .each do|route|
              if route.destination == destination
                final_paths << previous_path + [route]
              else
                route_traversal(routes, route.destination, destination, final_paths, previous_path + [route])
              end
            end
          final_paths
        end
      end
    end
  end
end
