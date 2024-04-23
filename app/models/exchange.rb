# frozen_string_literal: true

class Exchange
  attr_reader :date, :rate, :currency

  def initialize(date, currency, rate)
    @date = date.to_s
    @currency = currency.to_s.upcase
    @rate = rate
  end

  class << self
    attr_reader :rates

    def rate(date, currency)
      ex_rate = Exchange.rates.find { |rate| rate.date == date.to_s && rate.currency == currency }
      return Float::INFINITY if ex_rate.nil?

      ex_rate.rate
    end

    def seed(rates)
      @rates = []
      rates.each do |date, currency_rate|
        currency_rate.each do |currency, rate|
          @rates << new(date, currency, rate)
        end
      end
    end

    def clear
      @rates = nil
    end
  end
end
