# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sendcloud::Client do
  describe ".configure" do
    it "raises an exception without a block" do
      expect { described_class.configure }.to raise_error(ArgumentError, "block not given")
    end

    it "provides a config object in the block" do
      described_class.configure do |config|
        expect(config).to be_instance_of(Sendcloud::Config)
      end
    end
  end
end
