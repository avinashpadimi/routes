# frozen_string_literal: true

require 'sinatra/base'

module Api
  module Controllers
    class Base < Sinatra::Base
      include Api::Helpers::Errors
      include Api::Helpers::Responses

      configure do
        enable :raise_errors
        enable :logging unless test?
      end
      before { content_type(:json) }

      error Sinatra::NotFound do
        not_found([{ code: :not_found }])
      end
    end
  end
end
