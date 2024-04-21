ROOT_DIR = File.dirname(File.expand_path('..', __FILE__)).freeze

(Dir[
  './app/models/**/*.rb',
  './app/Serializers/**/*.rb',
  './app/services/**/*.rb',
  './app/helpers/**/*.rb',
  './app/controllers/**/*.rb',
  './config/initializers/**/*.rb'
]).uniq.each {|rb| require rb}
