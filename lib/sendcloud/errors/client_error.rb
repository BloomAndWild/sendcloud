module Sendcloud
  module Errors
    class ClientError < StandardError
      attr_reader :body, :response

      def initialize(response:, body:)
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
