# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sendcloud::Operations::SenderAddressesRequest do
  let(:default_base_url) { "https://panel.sendcloud.sc/api/v2/" }

  before do
    configure_client(base_url: default_base_url)
  end

  describe "#execute" do
    let(:subject) { described_class.new }

    it "returns a response in the expected format", :aggregate_failures do
      VCR.use_cassette("sender_addresses_request/valid_request") do
        result = subject.execute

        expect(subject.response.status).to eq(200)
        expect(result).to be_instance_of(Array)

        expect(result.find { |sender_address| sender_address[:label] == "Innovation Centre" }).to match(
          hash_including(
            {
              label: "Innovation Centre",
              id: 393806
            }
          )
        )
      end
    end
  end
end
