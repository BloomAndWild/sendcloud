# frozen_string_literal: true

module Sendcloud
  module Operations
    class CreateShipmentRequest < Operation
      def execute
        parcel_data = create_parcel
        label_data = request_label(parcel_data)
        merge_parcel_with_label(parcel_data, label_data)
      end

      private

      def merge_parcel_with_label(parcel_data, label_data)
        parcel_data[:pdf_label] = label_data
        parcel_data
      end

      def request_label(parcel_data)
        execute_request(PrinterLabelRequest.new(parcel_id: parcel_data[:id]))
      end

      def create_parcel
        execute_request(CreateParcelRequest.new(payload: payload))
      end

      def execute_request(request)
        request.execute
      ensure
        @response = request.response
      end
    end
  end
end
