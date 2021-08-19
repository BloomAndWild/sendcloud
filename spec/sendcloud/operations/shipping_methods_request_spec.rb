# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sendcloud::Operations::ShippingMethodsRequest do
  let(:default_base_url) { "https://panel.sendcloud.sc/api/v2/" }

  before do
    configure_client(base_url: default_base_url)
  end

  describe "#execute" do
    let(:subject) { described_class.new }

    it "returns a response in the expected format" do
      VCR.use_cassette("shipping_methods_request/valid_request") do
        result = subject.execute

        aggregate_failures do
          expect(subject.response.status).to eq(200)
          expect(result).to be_instance_of(Array)
          expect(result.first.keys).to include(:id, :name, :carrier, :price)

          # "Unstamped letter" is the test shipping method that we
          # can expect to remain constant over time
          # https://support.sendcloud.com/hc/en-us/articles/207948986-Can-I-create-test-labels-with-Sendcloud-
          expect(result.find { |sm| sm[:name] == "Unstamped letter" }).to match(
            hash_including(
              {
                name: "Unstamped letter",
                carrier: "sendcloud",
                price: 0
              }
            )
          )
        end
      end
    end
  end
end
