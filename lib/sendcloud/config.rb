# frozen_string_literal: true

module Sendcloud
  class Config
    attr_accessor :base_url, :public_key, :secret_key
    attr_reader :logger

    def logger=(logger = nil)
      @logger = logger || Logger.new($stdout)
      @logger.level ||= Logger::DEBUG
    end

    def log_responses=(log_responses = :all)
      @log_responses = if %i[all none failed].include?(log_responses)
        log_responses
      else
        :all
      end
    end

    def log_responses
      @log_responses ||= :all
    end
  end
end
