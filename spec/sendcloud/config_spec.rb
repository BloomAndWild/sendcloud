# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sendcloud::Config do
  it { is_expected.to respond_to(:base_url, :base_url=) }
  it { is_expected.to respond_to(:public_key, :public_key=) }
  it { is_expected.to respond_to(:secret_key, :secret_key=) }
  it { is_expected.to respond_to(:logger, :logger=) }
end
