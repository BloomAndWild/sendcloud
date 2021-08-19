module Sendcloud
  module Errors
    class ResponseError < StandardError
      attr_reader :payload, :body

      def initialize(payload:, response:, body:)
        @payload = payload
        @response = response
        @body = body

        super(build_message)
      end

      private

      def build_message
        "#{response.status} #{body[:status]} #{body[:message]}"
      end
    end
  end
end
