require "spec_helper"

RSpec.describe Sendcloud::Operation do
  let(:default_base_url) { "https://panel.sendcloud.sc/api/v2/" }

  let(:default_class) do
    Class.new(described_class) do
      def http_method
        :get
      end

      def endpoint
        "parcels/statuses"
      end
    end
  end

  context "authentication" do
    context "with valid credentials" do
      before do
        configure_client(base_url: default_base_url)
      end

      it "returns 200 response" do
        VCR.use_cassette("operation/correct_credentials") do
          operation = default_class.new

          aggregate_failures do
            expect { operation.execute }.not_to raise_error
            expect(operation.response.status).to eq(200)
          end
        end
      end
    end

    context "with invalid credentials" do
      before do
        configure_client(base_url: default_base_url, public_key: "broken", secret_key: "wrong")
      end

      it "raises an exception" do
        VCR.use_cassette("operation/incorrect_credentials") do
          operation = default_class.new

          aggregate_failures do
            expect {
              operation.execute
            }.to raise_error(
              Sendcloud::ResponseError, "401 Invalid username/password."
            )
            expect(operation.response.status).to eq(401)
          end
        end
      end
    end
  end
end
