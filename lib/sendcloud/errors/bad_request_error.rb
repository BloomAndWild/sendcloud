module Sendcloud
  module Errors
    class BadRequestError < StandardError
      attr_reader :payload, :body

      def initialize(payload:, body:)
        @payload = payload
        @body = body

        super(build_message)
      end

      private

      def build_message
        "#{body[:error][:code]} #{body[:error][:message]}"
      end
    end
  end
end
