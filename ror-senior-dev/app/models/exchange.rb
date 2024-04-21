class Exchange
  @rates = []
  attr_accessor :date,:rate,:currency

  def initialize date, currency, rate
    @date = date.to_s
    @currency = currency.to_s.upcase
    @rate = rate
  end

  class << self
    def rates
      @rates
    end

    def rate(date,currency)
      ex_rate = Exchange.rates.find(){|rate| rate.date == date && rate.currency == currency}
      return Float::INFINITY if ex_rate.nil?
      ex_rate.rate
    end

    def generate rates
      rates.each do |date, currency_rate|
        currency_rate.each do |currency, rate|
          @rates << new(date,currency,rate)
        end
      end
    end
  end
end
