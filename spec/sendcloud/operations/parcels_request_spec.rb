# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sendcloud::Operations::ParcelsRequest do
  let(:default_base_url) { "https://panel.sendcloud.sc/api/v2/" }

  before { configure_client(base_url: default_base_url) }

  describe "#execute" do
    context "without updated_after" do
      subject { described_class.new }

      it "returns parcels" do
        VCR.use_cassette("parcels_request/without_updated_after") do
          result = subject.execute

          expect(result.length).to eq(23)
        end
      end
    end

    context "with updated_after" do
      subject { described_class.new(updated_after: "2021-09-10 00:00:00.000Z") }

      it "returns parcels after the specified date" do
        VCR.use_cassette("parcels_request/with_updated_after") do
          result = subject.execute

          expect(result.length).to eq(11)
        end
      end
    end
  end
end
