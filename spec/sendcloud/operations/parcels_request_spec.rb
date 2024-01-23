# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sendcloud::Operations::ParcelsRequest do
  let(:default_base_url) { "https://panel.sendcloud.sc/api/v2/" }

  before { configure_client(base_url: default_base_url) }

  describe "#execute" do
    subject { described_class.new }

    it "returns the full response body" do
      VCR.use_cassette("parcels_request/without_updated_after") do
        result = subject.execute

        expect(result.has_key?(:parcels)).to be_truthy
        expect(result.has_key?(:previous)).to be_truthy
        expect(result.has_key?(:next)).to be_truthy
      end
    end

    context "without updated_after" do
      it "returns parcels" do
        VCR.use_cassette("parcels_request/without_updated_after") do
          result = subject.execute

          expect(result[:parcels].length).to eq(100)
        end
      end

      context "when cursor is provided" do
        let(:cursor) { "cD0zMDI2NjcxNjI=" }
        subject { described_class.new(cursor: cursor) }

        it "includes cursor in the request URL" do
          VCR.use_cassette("parcels_request/without_updated_after_with_cursor") do
            result = subject.execute

            expect(result[:parcels].length).to eq(100)
          end
        end
      end
    end

    context "with updated_after" do
      let(:updated_after) { DateTime.parse("2021-09-10 00:00:00.000Z") }
      subject { described_class.new(updated_after: updated_after) }

      it "returns parcels after the specified date" do
        VCR.use_cassette("parcels_request/with_updated_after") do
          result = subject.execute

          expect(result[:parcels].length).to eq(100)
        end
      end

      context "when cursor is provided" do
        let(:cursor) { "cD0zMDI2NjcxNjI=" }
        subject { described_class.new(updated_after: updated_after, cursor: cursor) }

        it "includes cursor in the request URL" do
          VCR.use_cassette("parcels_request/with_updated_after_with_cursor") do
            result = subject.execute

            expect(result[:parcels].length).to eq(100)
          end
        end
      end
    end
  end
end
