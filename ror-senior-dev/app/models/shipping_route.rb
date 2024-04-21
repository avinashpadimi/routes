class ShippingRoute
  @routes = nil
  attr_accessor :origin, :destination, :dep_date, :arr_date, :code, :shipping_rate

  def initialize(route, shipping_rate)
    @origin = route[:origin_port]
    @destination = route[:destination_port]
    @dep_date = route[:departure_date]
    @arr_date = route[:arrival_date]
    @code = route[:sailing_code]
    @shipping_rate = shipping_rate
  end

  class << self
    def routes
      @routes
    end

    def generate(routes, shipping_rates)
      @routes ||= routes.map do |route|
        shipping_rate = shipping_rates[route[:sailing_code]]
        new(route,shipping_rate)
      end
    end
  end
end
