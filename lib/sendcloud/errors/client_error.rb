module Sendcloud
  module Errors
    class ClientError < StandardError
      attr_reader :body, :status

      def initialize(status:, body:)
        @status = status
        @body = body

        super(build_message)
      end

      private

      def build_message
        "#{status} #{body[:status]} #{body[:message]}"
      end
    end
  end
end
