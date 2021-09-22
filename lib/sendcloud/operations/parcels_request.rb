# frozen_string_literal: true

module Sendcloud
  module Operations
    class ParcelsRequest < Operation
      private

      def handle_response_body(body)
        body[:parcels]
      end

      def endpoint
        params = if !!options[:updated_after]
          "?updated_after=#{options[:updated_after]}"
        else
          ""
        end

        "parcels#{params}"
      end

      def http_method
        :get
      end
    end
  end
end
