module Sendcloud
  module Operations
    class CancelParcelRequest < Operation
      private

      def http_method
        :post
      end

      def endpoint
        "parcels/#{parcel_id}/cancel"
      end

      def parcel_id
        options[:parcel_id]
      end

      def handle_error(body)
        case response.status
        when 400
          raise BadRequestError.new(status: response.status, body: body)
        when 410
          raise DeletedError.new(status: response.status, body: body)
        else
          super
        end
      end
    end
  end
end
