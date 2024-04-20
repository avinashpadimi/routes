require 'sinatra/base'

module Api
  module Controllers
    class Base < Sinatra::Base
      configure do
        enable :raise_errors
        enable :logging unless test?
      end
      before {content_type(:json)}

      error Sinatra::NotFound do
      end
    end
  end
end
