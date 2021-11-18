module Sendcloud
  class LogFormatter < Faraday::Logging::Formatter
    def request(env); end

    def response(env)
      return if log_none? || log_failed? && env.success?

      log_request(env)
      super(env)
    end

    def log_request(env)
      request_log = proc do
        "#{env.method.upcase} #{apply_filters(env.url.to_s)}"
      end
      public_send(log_level, "request", &request_log)

      log_headers("request", env.request_headers) if log_headers?(:request)
      log_body("request", env[:body]) if env[:body] && log_body?(:request)
    end

    private

    def log_responses
      @options[:log_responses]
    end

    def log_none?
      log_responses == :none
    end

    def log_failed?
      log_responses == :failed
    end
  end
end
