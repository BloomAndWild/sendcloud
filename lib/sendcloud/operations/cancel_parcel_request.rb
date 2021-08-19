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
    end
  end
end
