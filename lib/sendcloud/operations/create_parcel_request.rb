# frozen_string_literal: true

module Sendcloud
  module Operations
    class CreateParcelRequest < Operation
      private

      def payload
        { parcel: options[:payload] }
      end

      def handle_response_body(body)
        body[:parcel]
      end

      def endpoint
        "parcels"
      end

      def http_method
        :post
      end
    end
  end
end
