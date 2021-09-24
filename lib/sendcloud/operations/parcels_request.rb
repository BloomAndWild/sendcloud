# frozen_string_literal: true

module Sendcloud
  module Operations
    class ParcelsRequest < Operation
      private

      def handle_response_body(body)
        body[:parcels]
      end

      def endpoint
        path = "parcels"

        if request_params
          path += "?#{request_params}"
        end

        path
      end

      def http_method
        :get
      end

      def request_params
        @request_params ||= begin
          params = [
            [:updated_after, updated_after],
            [:cursor, cursor]
          ].reject do |k,v|
            v.nil?
          end

          URI.encode_www_form(params)
        end
      end

      def updated_after
        options[:updated_after]&.iso8601
      end

      def cursor
        options[:cursor]
      end
    end
  end
end
