require 'rack/test'
require_relative '../config/application'

ENV['RACK_ENV'] = "test"

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
