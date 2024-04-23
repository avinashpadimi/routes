# frozen_string_literal: true

class ShippingRate
  attr_reader :code, :rate, :currency

  def initialize(rate)
    @code = rate[:sailing_code]
    @rate = rate[:rate]
    @currency = rate[:rate_currency]
  end

  class << self
    attr_reader :rates

    def seed(rates)
      @rates = rates.map { |rate| new(rate) }
    end

    def by_code
      rates.each_with_object({}) do |rate, obj|
        obj[rate.code] = rate
      end
    end

    def clear
      @rates = nil
    end
  end
end
