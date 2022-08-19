# frozen_string_literal: true

require "base64"

module Sendcloud
  module Operations
    class PrinterLabelRequest < Operation
      def execute
        http_client = Faraday.new do |conn|
          conn.request(:authorization, :basic, public_key, secret_key)
        end

        @response = http_client.run_request(http_method, api_url, payload, headers)

        if response.success?
          Base64.strict_encode64(response.body)
        else
          body = JSON.parse(response.body, symbolize_names: true)
          handle_error(body)
        end
      end

      private

      def payload
        ""
      end

      def http_method
        :get
      end

      def endpoint
        "labels/label_printer/#{options[:parcel_id]}"
      end
    end
  end
end
