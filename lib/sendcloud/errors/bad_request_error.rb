module Sendcloud
  module Errors
    class BadRequestError < StandardError
      attr_reader :payload, :body

      def initialize(payload:, response:, body:)
        @payload = payload
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
