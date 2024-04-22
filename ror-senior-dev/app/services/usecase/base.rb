# frozen_string_literal: true

module Api
  module Services
    module Usecase
      class Base
        attr_reader :handler, :exchange_handler, :params, :errors

        def self.execute(handler, exchange_handler, params)
          new(handler, exchange_handler, params).execute
        end

        def execute
          validate_params
          return failure unless errors.empty?

          return success([]) if routes.empty?

          success(call)
        end

        private_class_method :new

        private

        def initialize(handler, exchange_handler, params)
          @handler = handler
          @exchange_handler = exchange_handler
          @params = params
          @errors = []
        end

        def call
          raise NotImplementedError, "#{self.class} has not implemented method #{__method__}"
        end

        def routes
          @routes ||= handler.routes(params[:origin], params[:destination])
        end

        def validate_params
          errors << { code: :bad_request } if params_empty?
        end

        def params_empty?
          %i(origin destination).any? do |input|
            params[input].nil? || params[input].strip.empty?
          end
        end

        def success(data)
          OpenStruct.new(data: [data].flatten, errors: errors)
        end

        def failure
          OpenStruct.new(errors: errors)
        end
      end
    end
  end
end
