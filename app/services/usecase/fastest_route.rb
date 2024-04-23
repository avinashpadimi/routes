# frozen_string_literal: true

require_relative './base'

module Api
  module Services
    module Usecase
      class FastestRoute < Base
        private

        def call
          handler.fastest_route(routes)
        end

        def routes
          @routes ||= handler.routes(params[:origin], params[:destination])
        end
      end
    end
  end
end
