module Sendcloud
  class LogFormatter
    # This should inherit from Faraday::Logging::Formatter
    # Versions ~> 0.17.0 of Faraday have the formatter removed
    # This is copied and adapted from
    # https://github.com/lostisland/faraday/blob/v1.8.0/lib/faraday/logging/formatter.rb
    extend Forwardable

    DEFAULT_OPTIONS = { headers: true, bodies: false,
                        log_level: :info
}.freeze

    def initialize(logger:, options:)
      @logger = logger
      @filter = []
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def_delegators :@logger, :debug, :info, :warn, :error, :fatal

    def request(_env); end

    def response(env)
      return if log_none? || log_failed? && env.success?

      log_request(env)
      status = proc { "Status #{env.status}" }
      public_send(log_level, "response", &status)

      log_headers("response", env.response_headers) if log_headers?(:response)
      log_body("response", env[:body]) if env[:body] && log_body?(:response)
    end

    def log_request(env)
      request_log = proc do
        "#{env.method.upcase} #{apply_filters(env.url.to_s)}"
      end
      public_send(log_level, "request", &request_log)

      log_headers("request", env.request_headers) if log_headers?(:request)
      log_body("request", env[:body]) if env[:body] && log_body?(:request)
    end

    def filter(filter_word, filter_replacement)
      @filter.push([filter_word, filter_replacement])
    end

    private

    def dump_headers(headers)
      headers.map { |k, v| "#{k}: #{v.inspect}" }.join("\n")
    end

    def dump_body(body)
      if body.respond_to?(:to_str)
        body.to_str
      else
        pretty_inspect(body)
      end
    end

    def pretty_inspect(body)
      body.pretty_inspect
    end

    def log_headers?(type)
      case @options[:headers]
      when Hash
        @options[:headers][type]
      else
        @options[:headers]
      end
    end

    def log_body?(type)
      case @options[:bodies]
      when Hash
        @options[:bodies][type]
      else
        @options[:bodies]
      end
    end

    def apply_filters(output)
      @filter.each do |pattern, replacement|
        output = output.to_s.gsub(pattern, replacement)
      end
      output
    end

    def log_level
      unless %i[debug info warn error fatal].include?(@options[:log_level])
        return :info
      end

      @options[:log_level]
    end

    def log_headers(type, headers)
      headers_log = proc { apply_filters(dump_headers(headers)) }
      public_send(log_level, type, &headers_log)
    end

    def log_body(type, body)
      body_log = proc { apply_filters(dump_body(body)) }
      public_send(log_level, type, &body_log)
    end

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
