# frozen_string_literal: true

module Api
  module Serializers
    class ShippingRoute
      attr_accessor :routes

      def initialize(routes)
        @routes = routes
      end

      def self.serialize(routes)
        new(routes).execute
      end

      def execute
        routes.map do |route|
          hash = {
            origin_port: route.origin,
            destination_port: route.destination,
            departure_date: route.dep_date.to_s,
            arrival_date: route.arr_date.to_s,
            sailing_code: route.code
          }

          unless route.shipping_rate.nil?
            hash.merge!(
              {
                rate: route.shipping_rate.rate,
                rate_currency: route.shipping_rate.currency
              }
            )
          end
          hash
        end
      end

      private_class_method :new
    end
  end
end
