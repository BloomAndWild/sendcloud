# frozen_string_literal: true

module Sendcloud
  class Config
    attr_accessor :base_url, :public_key, :secret_key
    attr_reader :logger

    def logger=(logger = nil)
      @logger = logger || Logger.new($stdout)
      @logger.level ||= Logger::DEBUG
    end
  end
end
