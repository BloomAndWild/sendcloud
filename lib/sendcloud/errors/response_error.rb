module Sendcloud
  module Errors
    class ResponseError < StandardError
      attr_reader :payload, :body, :status, :response

      def initialize(payload:, body:, status:, response:)
        @payload = payload
        @body = body
        @status = status
        @response = sanitized_response(response)

        super(build_message)
      end

      private

      def build_message
        "Sendcloud error: #{status} - #{body[:error][:message]}"
      end

      def sanitized_response(raw_response)
        raw_response.to_hash.tap do |r|
          %i[request_headers request].each { |key| r.delete(key) }
        end.inspect
      end
    end
  end
end
