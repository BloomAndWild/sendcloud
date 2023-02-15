# frozen_string_literal: true

module Sendcloud
  module Operations
    class SenderAddressesRequest < Operation
      private

      def handle_response_body(body)
        body[:sender_addresses]
      end

      def endpoint
        "user/addresses/sender"
      end

      def http_method
        :get
      end
    end
  end
end
