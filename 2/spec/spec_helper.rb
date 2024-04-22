# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'rack/test'
require_relative '../config/application'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

ROUTES_FILE_PATH = File.join(ROOT_DIR, 'response.json')
ROUTES_DATA = JSON.parse(File.read(ROUTES_FILE_PATH), { symbolize_names: true })
def seed routes_data
  ShippingRate.seed(routes_data[:rates])
  Exchange.seed(routes_data[:exchange_rates])
  ShippingRoute.seed(routes_data[:sailings], ShippingRate.by_code)
end

def clear
  ShippingRate.clear
  Exchange.clear
  ShippingRoute.clear
end
