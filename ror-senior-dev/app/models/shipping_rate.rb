class ShippingRate
  @rates = nil
  attr_accessor :code, :rate, :currency

  def initialize rate
    @code = rate[:sailing_code]
    @rate = rate[:rate]
    @currency = rate[:rate_currency]
  end

  class << self
    def rates
      @rates
    end

    def generate rates
      @rates ||= rates.map do |rate|
        new(rate)
      end
    end

    def by_code
      @rates.each_with_object({}) do |rate, obj|
        obj[rate.code] = rate
      end
    end
  end
end
