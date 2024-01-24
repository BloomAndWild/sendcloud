# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sendcloud::Operations::TrackingRequest do
  let(:default_base_url) { "https://panel.sendcloud.sc/api/v2/" }

  before { configure_client(base_url: default_base_url) }

  describe "#execute" do
    subject { described_class.new(parcel_id: parcel_id) }

    context "with an invalid parcel id" do
      let(:parcel_id) { "0" }

      it "raises a not found exception" do
        VCR.use_cassette("tracking_request/invalid_parcel_id") do
          aggregate_failures do
            expect {
              subject.execute
            }.to raise_error(
              Sendcloud::Errors::ResponseError, "Sendcloud error: 404 - No Parcel matches the given query."
            )
            expect(subject.response.status).to eq(404)
          end
        end
      end
    end

    context "with a valid parcel ID" do
      # TODO: Create a valid parcel as part of setup using
      #       e.g. CreateParcelRequest
      let(:parcel_id) { "343492699" }

      it "retrieves the tracking information for the parcel" do
        VCR.use_cassette("tracking_request/valid_parcel_id") do
          result = subject.execute

          aggregate_failures do
            expect(subject.response.status).to eq(200)

            expect(result).to be_instance_of(Hash)
            expect(result).to eq(
              {
                tracking_number: "SCCWF3HMRH7Y",
                tracking_url: "https://tracking.eu-central-1-0.sendcloud.sc/forward?carrier=sendcloud&code=SCCWF3HMRH7Y&destination=NL&lang=en-us&source=NL&type=letter&verification=5642+CV&servicepoint_verification=&created_at=2024-01-23",
                carrier: {
                  code: "sendcloud",
                },
                status: {
                  id: 1000,
                  message: "Ready to send",
                },
                date_updated: "23-01-2024 09:49:04",
              }
            )
          end
        end
      end
    end
  end
end
