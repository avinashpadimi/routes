file_path = File.join(ROOT_DIR, 'response.json')
routes_data = JSON.parse(File.read(file_path), { symbolize_names: true })

ShippingRate.generate(routes_data[:rates])
Exchange.generate(routes_data[:exchange_rates])
ShippingRoute.generate(routes_data[:sailings], ShippingRate.by_code)
