module Api
  module Helpers
    module Responses
      def success data
        halt 200, { data: data }.to_json
      end
    end
  end
end
