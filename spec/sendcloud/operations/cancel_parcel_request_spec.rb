# frozen_string_literal: true
require "spec_helper"

RSpec.describe Sendcloud::Operations::CancelParcelRequest do
  let(:default_base_url) { "https://panel.sendcloud.sc/api/v2/" }

  before { configure_client(base_url: default_base_url) }

  describe '#execute' do
    subject { described_class.new(parcel_id: parcel_id) }

    context "with invalid parcel id" do
      let(:parcel_id) { "0" }

      it "raises a not found exception" do
        VCR.use_cassette("cancel_parcel_request/invalid_id") do
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

    context "when parcel is valid" do
      let(:parcel_id) { "124320972" }

      it "cancels the parcel" do
        VCR.use_cassette("cancel_parcel_request/valid_parcel") do
          result = subject.execute

          aggregate_failures do
            expect(subject.response.status).to eq(200)
            
            expect(result).to be_instance_of(Hash)
            expect(result.keys).to include(:message, :status)

            expect(result).to match(hash_including(
              message: "Parcel has been cancelled",
              status: "cancelled"
            ))
          end
        end
      end
    end

    context "when parcel is deleted" do
      let(:parcel_id) { "124309702" }

      it "raise deleted error" do
        VCR.use_cassette("cancel_parcel_request/deleted_parcel") do
          aggregate_failures do
            expect {
              subject.execute
            }.to raise_error(
              Sendcloud::Errors::DeletedError, "410 deleted Parcel has been deleted"
            )
            expect(subject.response.status).to eq(410)
          end
        end
      end
    end

    context "when parcel is already cancelled" do
      let(:parcel_id) { "124068875" }

      it "raises a bad request exception" do
        VCR.use_cassette("cancel_parcel_request/already_cancelled") do
          aggregate_failures do
            expect {
              subject.execute
            }.to raise_error(
              Sendcloud::Errors::BadRequestError, "400 failed This shipment is already being cancelled."
            )
            expect(subject.response.status).to eq(400)
          end
        end
      end
    end
  end
end
