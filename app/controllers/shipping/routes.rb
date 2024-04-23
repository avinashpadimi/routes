# frozen_string_literal: true

require_relative '../base'

module Api
  module Controllers
    module Shipping
      class Routes < Base
        get '/cheapest' do
          resp = Api::Services::Usecase::CheapestRoute.execute(shipping_handler, exchange_handler, params)
          unprocessiable(resp.errors) unless resp.errors.empty?
          success(serialize(resp.data))
        end

        get '/cheapest/direct' do
          resp = Api::Services::Usecase::CheapestDirectRoute.execute(shipping_handler, exchange_handler, params)
          unprocessiable(resp.errors) unless resp.errors.empty?
          success(serialize(resp.data))
        end

        get '/fastest' do
          resp = Api::Services::Usecase::FastestRoute.execute(shipping_handler, nil, params)
          unprocessiable(resp.errors) unless resp.errors.empty?
          success(serialize(resp.data))
        end

        private

        def serialize(data)
          Api::Serializers::ShippingRoute.serialize(data)
        end

        def shipping_handler
          Api::Services::Shipping::Handler.new
        end

        def exchange_handler
          Api::Services::Exchange::Handler.new
        end
      end
    end
  end
end
