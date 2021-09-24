# frozen_string_literal: true

module Sendcloud
  module Operations
    class ParcelsRequest < Operation
      private

      def handle_response_body(body)
        body[:parcels]
      end

      def endpoint
        params = if updated_after
          "?updated_after=#{CGI.escape(updated_after)}"
        else
          ""
        end

        "parcels#{params}"
      end

      def http_method
        :get
      end

      def updated_after
        @updated_after ||= begin
          return unless !!options[:updated_after]

          options[:updated_after].iso8601
        end
      end
    end
  end
end
