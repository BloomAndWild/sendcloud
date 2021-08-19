module Sendcloud
  module Operations
    class CancelParcelRequest < Operation

      protected

      def http_method
        :post
      end

      def endpoint
        "parcels/#{parcel_id}/cancel"
      end
      
      def parcel_id
        options[:parcel_id]
      end

      private

      def handle_error(body)
        if response.status == 400
          raise BadRequestError.new(response: response, body: body)
        else
          super
        end
      end
    end
  end
end
