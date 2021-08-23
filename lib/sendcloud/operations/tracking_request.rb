# frozen_string_literal: true

module Sendcloud
  module Operations
    class TrackingRequest < Operation
      TRACKING_PARAMS = [
        :tracking_number,
        :tracking_url,
        :carrier,
        :status
      ].freeze

      private

      def handle_response_body(body)
        body[:parcel].slice(*TRACKING_PARAMS)
      end

      def endpoint
        "parcels/#{options[:parcel_id]}"
      end

      def http_method
        :get
      end
    end
  end
end
