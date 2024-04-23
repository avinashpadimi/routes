# frozen_string_literal: true

module Api
  module Helpers
    module Errors
      def not_found(errors)
        halt(404, error(errors))
      end

      def unprocessiable(errors)
        halt(422, error(errors))
      end

      def internal_server_error(errors)
        halt(500, error(errors))
      end

      private

      def error(errors)
        {
          errors: errors.map do |error|
            {
              code: fetch_code(error[:code]),
              detail: detail(error[:code])
            }
          end
        }.to_json
      end

      def fetch_code(code)
        case code
        when :bad_request then 400
        when :not_found then 404
        when :internal_server_error, :failure then 500
        else
          500
        end
      end

      def detail(code)
        case code
        when :bad_request then 'required parameters are missing or invalid'
        when :not_found then 'url not found'
        when :internal_server_error, :failure then 'internal server error'
        else
          'internal server error'
        end
      end
    end
  end
end
