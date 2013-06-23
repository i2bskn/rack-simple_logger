# Rack::SimpleLogger

[![Gem Version](https://badge.fury.io/rb/rack-simple_logger.png)](http://badge.fury.io/rb/rack-simple_logger)
[![Build Status](https://travis-ci.org/i2bskn/rack-simple_logger.png?branch=master)](https://travis-ci.org/i2bskn/rack-simple_logger)
[![Coverage Status](https://coveralls.io/repos/i2bskn/rack-simple_logger/badge.png?branch=master)](https://coveralls.io/r/i2bskn/rack-simple_logger?branch=master)
[![Code Climate](https://codeclimate.com/github/i2bskn/rack-simple_logger.png)](https://codeclimate.com/github/i2bskn/rack-simple_logger)

Simple logger for rack.

## Installation

Add this line to your application's Gemfile:

    gem 'rack-simple_logger'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-simple_logger

## Usage

Include as Rack middleware to config.ru.

for local file:

```ruby
require "rack_application"
require "rack/simple_logger"

use Rack::SimpleLogger, log: File.expand_path("../log/production.log", __FILE__)
run RackApplication.new
```

for MongoDB:

```ruby
require "rack_application"
require "mongo"
require "rack/simple_logger"

client = Mongo::Connection.new("localhost", 27017)
database = client["logs"]
collection = database["racklog"]

use Rack::SimpleLogger, log: collection
run RackApplication.new
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
