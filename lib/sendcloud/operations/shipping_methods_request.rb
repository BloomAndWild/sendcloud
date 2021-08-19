# frozen_string_literal: true

module Sendcloud
  module Operations
    class ShippingMethodsRequest < Operation
      private

      def handle_response_body(body)
        body[:shipping_methods]
      end

      def endpoint
        "shipping_methods"
      end

      def http_method
        :get
      end
    end
  end
end
