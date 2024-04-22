# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ShippingRoute do
  describe '#seed' do
    let(:routes) do
      [
        {
          origin_port: 'CNSHA',
          destination_port: 'ESBCN',
          departure_date: '2022-01-29',
          arrival_date: '2022-02-12',
          sailing_code: 'ERXQ'
        }
      ]
    end

    let(:shipping_rates) do
      { 'ERXQ' => double(:shipping_rate, sailing_code: 'ERXQ', rate: 10.5) }
    end
    context 'given routes & shipping_rates' do
      it 'should create routes' do
        described_class.seed(routes, shipping_rates)
        got_routes = described_class.routes
        expect(got_routes.size).to eq(1)
        got_routes.each_with_index do |route, index|
          exp_route = routes[index]
          expect(route.origin).to eq(exp_route[:origin_port])
          expect(route.shipping_rate.rate).to eq(shipping_rates[exp_route[:sailing_code]].rate)
        end
      end
    end
  end
end
