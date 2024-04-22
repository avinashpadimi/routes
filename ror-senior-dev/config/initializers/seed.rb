# frozen_string_literal: true

unless ENV['RACK_ENV'] == 'test'
  file_path = File.join(ROOT_DIR, 'response.json')
  routes_data = JSON.parse(File.read(file_path), { symbolize_names: true })

  ShippingRate.seed(routes_data[:rates])
  Exchange.seed(routes_data[:exchange_rates])
  ShippingRoute.seed(routes_data[:sailings], ShippingRate.by_code)
end
