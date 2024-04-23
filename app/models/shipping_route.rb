# frozen_string_literal: true

class ShippingRoute
  attr_reader :origin, :destination, :dep_date, :arr_date, :code, :shipping_rate

  def initialize(route, shipping_rate)
    @origin = route[:origin_port]
    @destination = route[:destination_port]
    @dep_date = Date.parse(route[:departure_date])
    @arr_date = Date.parse(route[:arrival_date])
    @code = route[:sailing_code]
    @shipping_rate = shipping_rate
  end

  class << self
    attr_reader :routes

    def seed(routes, shipping_rates)
      @routes = routes.map do |route|
        shipping_rate = shipping_rates[route[:sailing_code]]
        new(route, shipping_rate)
      end
    end

    def clear
      @route = nil
    end
  end
end
