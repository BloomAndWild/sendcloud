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
              Sendcloud::Errors::ResponseError, "Sendcloud error: 401 - Invalid username/password."
            )
            expect(operation.response.status).to eq(401)
          end
        end
      end
    end

    context "with credentials as arguments" do
      before do
        # public_key and secret_key passed as arguments take precedence over the global config
        configure_client(base_url: default_base_url, public_key: "broken", secret_key: "wrong")
      end

      it "returns 200 response" do
        VCR.use_cassette("operation/credential_args") do
          operation = default_class.new(
            public_key: ENV.fetch("SENDCLOUD_PUBLIC_KEY", ""),
            secret_key: ENV.fetch("SENDCLOUD_SECRET_KEY", "")
          )

          aggregate_failures do
            expect { operation.execute }.not_to raise_error
            expect(operation.response.status).to eq(200)
          end
        end
      end
    end
  end

  context "without payload" do
    before do
      # public_key and secret_key passed as arguments take precedence over the global config
      configure_client(base_url: default_base_url, public_key: "broken", secret_key: "wrong")
    end

    it "sends a request with an empty body" do
      VCR.use_cassette("operation/request_body") do
        operation = default_class.new(
          public_key: ENV.fetch("SENDCLOUD_PUBLIC_KEY", ""),
          secret_key: ENV.fetch("SENDCLOUD_SECRET_KEY", "")
        )

        # NOTE: The main expectation is on the request's body
        expect(operation.http_client)
          .to receive(:run_request)
          .with(
            :get,
            "https://panel.sendcloud.sc/api/v2/parcels/statuses",
            nil,
            {content_type: "application/json"},
          )
          .and_call_original

        operation.execute
      end
    end
  end
end
