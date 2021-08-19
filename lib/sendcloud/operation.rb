module Sendcloud
  class Operation
    DEFAULT_HEADERS = {
      content_type: "application/json"
    }.freeze

    attr_reader :response, :payload

    def initialize(payload = {})
      @payload = payload
    end

    def execute
      http_client = Faraday.new
      http_client.basic_auth(public_key, secret_key)

      json_payload = JSON.generate(payload)
      @response = http_client.run_request(http_method, api_url, json_payload, headers)
      body = JSON.parse(response.body, symbolize_names: true)
      return handle_response_body(body) if response.success?

      raise ResponseError.new(payload: payload, body: body)
    end

    protected

    def http_method
      raise NoMethodError, "subclass must implement #{__method__}"
    end

    def endpoint
      raise NoMethodError, "subclass must implement #{__method__}"
    end

    private

    def handle_response_body(body)
      body
    end

    def api_url
      base_url + endpoint
    end

    def headers
      DEFAULT_HEADERS
    end

    def public_key
      config.public_key
    end

    def secret_key
      config.secret_key
    end

    def base_url
      config.base_url
    end

    def config
      Client.config
    end
  end
end