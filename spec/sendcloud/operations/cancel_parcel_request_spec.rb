# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sendcloud::Operations::CancelParcelRequest do
  let(:default_base_url) { "https://panel.sendcloud.sc/api/v2/" }

  before { configure_client(base_url: default_base_url) }

  describe "#execute" do
    subject { described_class.new(parcel_id: parcel_id) }

    context "with invalid parcel id" do
      let(:parcel_id) { "0" }

      it "raises a not found exception" do
        VCR.use_cassette("cancel_parcel_request/invalid_id") do
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

    context "when parcel is valid" do
      # TODO: Create a valid parcel as part of setup using
      #       e.g. CreateParcelRequest
      #
      # Q: What does valid mean in this context?
      # A: Since the /cancel endpoint can cancel OR delete a parcel
      #    depending on its state, we want a parcel in a state such
      #    that it will be cancelled instead of deleted.
      #    See: https://api.sendcloud.dev/docs/sendcloud-public-api/parcels%2Foperations%2Fcreate-a-parcel-cancel
      let(:parcel_id) { "255387317" }

      it "cancels the parcel" do
        VCR.use_cassette("cancel_parcel_request/valid_parcel") do
          result = subject.execute

          aggregate_failures do
            expect(subject.response.status).to eq(202)

            expect(result).to be_instance_of(Hash)
            expect(result.keys).to include(:message, :status)

            expect(result).to match(hash_including(
              message: "Parcel cancellation has been queued",
              status: "queued",
            ))
          end
        end
      end
    end

    context "when parcel is deleted" do
      # TODO: Create a deleted parcel as part of setup using
      #       e.g. CreateParcelRequest then CancelParcelRequest
      let(:parcel_id) { "343619161" }

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
      # TODO: Create a cancelled parcel as part of setup using
      #       e.g. CreateParcelRequest then CancelParcelRequest
      let(:parcel_id) { "341371285" }

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
