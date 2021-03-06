# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sendcloud::Operations::CreateParcelRequest do
  let(:default_base_url) { "https://panel.sendcloud.sc/api/v2/" }

  before do
    configure_client(base_url: default_base_url)
  end

  describe "#execute" do
    let(:payload) do
      {
        name: "John Doe",
        company_name: "Bloom&Wild",
        address: "Insulindelaan",
        house_number: "115",
        city: "Eindhoven",
        postal_code: "5642CV",
        telephone: "+31612345678",
        email: "hello@bloomandwild.com",
        data: [],
        country: "NL",
        order_number: "1234567890",
        shipping_method_checkout_name: "Unstamped letter", # "Unstamped letter" is the test shipping method that we can expect to remain constant over time
        request_label: true,
        shipment: {
          id: 8 # shipping method ID is required when request_label=true
        }
      }
    end

    let(:subject) { described_class.new(payload: payload) }

    context "valid request" do
      it "returns a response in the expected format" do
        VCR.use_cassette("create_parcel_request/valid_request") do
          result = subject.execute

          aggregate_failures do
            expect(subject.response.status).to eq(200)

            expect(result).to be_instance_of(Hash)
            expect(result.keys).to include(:id, :label, :tracking_number, :tracking_url)

            expect(result).to match(hash_including(
              name: "John Doe",
              company_name: "Bloom&Wild",
              address: "Insulindelaan 115",
              city: "Eindhoven",
              postal_code: "5642 CV",
              telephone: "+31612345678",
              email: "hello@bloomandwild.com",
              order_number: "1234567890",
              shipping_method_checkout_name: "Unstamped letter"
            ))
          end
        end
      end
    end

    context "invalid request" do
      before do
        payload.delete(:shipment)
      end

      it "raises an exception" do
        VCR.use_cassette("create_parcel_request/invalid_request") do
          aggregate_failures do
            expect { subject.execute }.to raise_error(
              Sendcloud::Errors::ResponseError,
              'Sendcloud error: 400 - shipping_method: "This field is required."'
            )
            expect(subject.response.status).to eq(400)
          end
        end
      end
    end

    context "invalid request with verbose carrier errors" do
      let(:payload) do
        {
          name: "John Doe",
          company_name: "Bloom&Wild",
          address: "Insulindelaan",
          house_number: "115",
          city: "Eindhoven",
          postal_code: "3316 EE", # Problematic postcode
          telephone: "+31612345678",
          email: "hello@bloomandwild.com",
          data: [],
          country: "NL",
          order_number: "1234567890",
          request_label: true,
          shipment: {
            id: 98 # Problematic shipping method (PostNL Evening where a lot of postcodes aren't supported)
          }
        }
      end

      it "raises an exception" do
        VCR.use_cassette("create_parcel_request/invalid_request_with_carrier_errors") do
          aggregate_failures do
            expect {
              subject.execute
            }.to raise_error(Sendcloud::Errors::ResponseError,
              'Sendcloud error: 400 - non_field_errors: "PostNL service error: \'1225029\'"')
            expect(subject.response.status).to eq(400)
          end
        end
      end
    end
  end
end
