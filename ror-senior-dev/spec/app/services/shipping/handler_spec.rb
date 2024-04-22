# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::Services::Shipping::Handler do

  def handler
    described_class.new
  end

  describe '#all_routes' do
    subject { handler.all_routes }
    context 'shipping routes' do
      it 'return all routes' do
        expect(subject.count).to eq(9)
      end
    end
  end

  describe '#direct_routes' do
    let(:origin) { 'CNSHA' }
    let(:destination) { 'NLRTM' }
    subject { handler.direct_routes(origin, destination) }
    context 'given origin & destination' do
      it 'return direct routes' do
        subject.each do |route|
          expect(route.origin).to eq(origin)
          expect(route.destination).to eq(destination)
        end
      end
    end

    context 'given invalid origin or destination' do
      let(:origin) { '' }
      it { is_expected.to be_empty }
    end
  end

  describe '#cheapest_route' do
    let(:route_cnsha_nlrtm) { double(origin: 'CNSHA', destination: 'NLRTM', shipping_rate: double(rate: 105.2)) }
    let(:route_brssz_esbcn) { double(origin: 'BRSSZ', destination: 'ESBCN', shipping_rate: double(rate: 20.2)) }
    let(:route_esbcn_nlrtm) { double(origin: 'ESBCN', destination: 'NLRTM', shipping_rate: nil) }
    let(:route_abcde_qwert) { double(origin: 'ABCDE', destination: 'QWERT', shipping_rate: double(rate: 15.2)) }
    let(:route_qwert_nlrtm) { double(origin: 'QWERT', destination: 'NLRTM', shipping_rate: double(rate: 20.5)) }

    let(:routes) { [route_cnsha_nlrtm, route_brssz_esbcn, route_esbcn_nlrtm] }
    subject { handler.cheapest_route(routes) }
    context 'given direct routes' do
      it 'return route with min cost' do
        route = subject
        expect(route.origin).to eq('BRSSZ')
        expect(route.destination).to eq('ESBCN')
      end
    end

    context 'givem mix of direct & in-direct routes' do
      let(:routes) do
        [
          route_cnsha_nlrtm,
          [route_brssz_esbcn, route_esbcn_nlrtm],
          [route_abcde_qwert, route_qwert_nlrtm]
        ]
      end

      it 'return route with min cost' do
        resp = subject
        [route_abcde_qwert, route_qwert_nlrtm].each_with_index do |route, index|
          expect(route.origin).to eq(resp[index].origin)
          expect(route.destination).to eq(resp[index].destination)
        end
      end
    end
  end

  describe '#routes' do
    let(:route_cnsha_nlrtm_0320) { double(id: 1, origin: 'CNSHA', destination: 'NLRTM', arr_date: '2024-04-20', dep_date: '2024-03-20') }
    let(:route_cnsha_nlrtm_0325) { double(id: 2, origin: 'CNSHA', destination: 'NLRTM', arr_date: '2024-04-23', dep_date: '2024-03-25') }
    let(:route_nlrtm_esbcn_0410) { double(id: 3, origin: 'NLRTM', destination: 'ESBCN', dep_date: '2024-04-10', arr_date: '2024-05-10') }
    let(:route_nlrtm_esbcn_0427) { double(id: 4, origin: 'NLRTM', destination: 'ESBCN', dep_date: '2024-04-27', arr_date: '2024-05-25') }

    let(:route_cnsha_esbcn_0322) { double(id: 5, origin: 'CNSHA', destination: 'ESBCN', dep_date: '2024-03-27', arr_date: '2024-05-25') }

    let(:routes) do
      [
        route_cnsha_nlrtm_0320,
        route_cnsha_nlrtm_0325,
        route_nlrtm_esbcn_0410,
        route_nlrtm_esbcn_0427,
        route_cnsha_esbcn_0322
      ]
    end
    let(:origin) { 'CNSHA' }
    let(:destination) { 'ESBCN' }
    subject { handler.routes(origin, destination) }
    context 'given origin & destination' do
      it 'return all possible routes' do
        allow_any_instance_of(described_class).to receive(:all_routes).and_return(routes)
        expected_routes = [
          [5],
          [1, 4],
          [2, 4]
        ]
        got_routes = subject
        expect(got_routes.count).to eq(3)
        got_route_ids = got_routes.map { |route| route.map(&:id) }
        expected_routes.each do |exp_route|
          got_route_ids.include?(exp_route)
        end
      end
    end
  end
end
