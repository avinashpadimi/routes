require_relative 'config/application'

map("/") { run Api::Controllers::Base }
map("/shipping/routes") { run Api::Controllers::Shipping::Routes }

