# frozen_string_literal: true

require "logger"

def configure_client(base_url: nil, public_key: nil, secret_key: nil)
  Sendcloud::Client.configure do |config|
    config.base_url = base_url || ENV.fetch("SENDCLOUD_BASE_URL")
    config.public_key = public_key || ENV.fetch("SENDCLOUD_PUBLIC_KEY", "")
    config.secret_key = secret_key || ENV.fetch("SENDCLOUD_SECRET_KEY", "")

    config.logger = Logger.new(File::NULL)
    config.logger.level = :debug
  end
end
