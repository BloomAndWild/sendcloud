# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sendcloud::Operations::PrinterLabelRequest do
  let(:default_base_url) { "https://panel.sendcloud.sc/api/v2/" }

  before do
    configure_client(base_url: default_base_url)
  end

  describe "#execute" do
    # taken from create_parcel_request/valid_request
    let(:parcel_id) { "124292020" }
    let(:subject) { described_class.new(parcel_id: parcel_id) }

    it "returns a response in the expected format" do
      VCR.use_cassette("printer_label_request/valid_request") do
        result = subject.execute

        aggregate_failures do
          expect(subject.response.status).to eq(200)
          expect(Base64::strict_decode64(result)).to match("%PDF") # checking for PDF header
        end
      end
    end
  end
end
