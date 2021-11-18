# Sendcloud

Ruby wrapper for Sendcloud's Rest API

Sendcloud API documentation: https://docs.sendcloud.sc/api/v2/shipping/


## Installation

Add this line to your application's Gemfile:

```ruby
gem "sendcloud", branch: "main", github: "BloomAndWild/sendcloud"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sendcloud

## Configuration

```ruby
  Sendcloud::Client.configure do |config|
    config.base_url = ENV.fetch("SENDCLOUD_BASE_URL", "")
    config.public_key = ENV.fetch("SENDCLOUD_PUBLIC_KEY", "")
    config.secret_key = ENV.fetch("SENDCLOUD_SECRET_KEY", "")

    config.logger = Logger.new($sdtout) # use the logger of your choice here. The format is set by LogFormatter
    config.logger.level = :debug
    config.log_responses = :all # :all, :none or :failed. Defaults to :all
  end
```

## Running specs

To run the specs, add your development credentials to your dev env:
```
SENDCLOUD_BASE_URL=https://panel.sendcloud.sc/api/v2/
SENDCLOUD_PUBLIC_KEY=<public_key>
SENDCLOUD_SECRET_KEY=<secret_key>
```

And run the specs via:

```
bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BloomAndWild/sendcloud.
