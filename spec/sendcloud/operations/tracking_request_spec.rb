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
              Sendcloud::Errors::ResponseError, "404 No Parcel matches the given query."
            )
            expect(subject.response.status).to eq(404)
          end
        end
      end
    end

    context "with a valid parcel ID" do
      let(:parcel_id) { "124320972" }

      it "retrieves the tracking information for the parcel" do
        VCR.use_cassette("tracking_request/valid_parcel_id") do
          result = subject.execute

          aggregate_failures do
            expect(subject.response.status).to eq(200)

            expect(result).to be_instance_of(Hash)
            expect(result).to eq(
              {
                tracking_number: "3SYZXG193621471",
                tracking_url: "https://tracking.sendcloud.sc/forward?carrier=postnl&code=3SYZXG193621471&destination=NL&lang=en-gb&source=NL&type=parcel&verification=5642+CV&created_at=2021-08-19",
                carrier: {
                  code: "postnl"
                },
                status: {
                  id: 2000,
                  message: "Cancelled"
                }
              }
            )
          end
        end
      end
    end
  end
end
