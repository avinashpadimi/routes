# frozen_string_literal: true

ROOT_DIR = File.dirname(File.expand_path('__dir__'))

(Dir[
  './lib/middlewares/**/*.rb',
  './app/models/**/*.rb',
  './app/Serializers/**/*.rb',
  './app/services/**/*.rb',
  './app/helpers/**/*.rb',
  './app/controllers/**/*.rb',
  './config/initializers/**/*.rb'
]).uniq.each { |rb| require rb }
