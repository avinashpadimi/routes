# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Services::Usecase::CheapestDirectRoute do
  let(:handler) { double(:handler) }
  let(:exchange_handler) { double(:exchange_handler) }
  let(:params) { { origin: origin, destination: destination } }
  let(:origin) { '' }
  let(:destination) { '' }

  describe '#execute' do
    subject { described_class.execute(handler, exchange_handler, params) }
    context 'given empty params' do
      it 'return bad request' do
        expected_error = [{ code: :bad_request }]
        expect(subject.errors).to match_array(expected_error)
      end
    end

    context 'no routes found' do
      let(:origin) { 'CNHSA' }
      let(:destination) { 'QWERT' }
      it 'return no routes' do
        expect(handler).to receive(:direct_routes).with(origin, destination).and_return([])
        expect(subject.data).to be_empty
      end
    end

    context 'cheapest direct route' do
      let(:handler) { Api::Services::Shipping::Handler.new }
      let(:route_abcde) { double(id: 1, dep_date: '2024-04-21', shipping_rate: double(rate: 40.5, currency: 'EUR')) }
      let(:route_qwert) { double(id: 2, dep_date: '2024-04-22', shipping_rate: double(rate: 20.5, currency: 'EUR')) }
      let(:routes) { [route_abcde, route_qwert] }
      let(:origin) { 'CNHSA' }
      let(:destination) { 'QWERT' }
      it 'return cheapest route' do
        expect(handler).to receive(:direct_routes).with(origin, destination).and_return(routes)
        routes.each do |route|
          expect(exchange_handler).to receive(:in_euros).with(
            route.dep_date,
            route.shipping_rate.currency,
            route.shipping_rate.rate
          ).and_return(route.shipping_rate.rate)
        end
        resp = subject
        expect(resp.data.count).to eq(1)
        expect(resp.data.first.id).to eq(2)
      end
    end
  end
end
