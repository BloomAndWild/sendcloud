module Sendcloud
  module Errors
    class ResponseError < StandardError
      attr_reader :payload, :body, :status

      def initialize(payload:, body:, status:)
        @payload = payload
        @body = body
        @status = status

        super(build_message)
      end

      private

      def build_message
        "#{status} #{body[:error][:message]}"
      end
    end
  end
end
