# Rack::SimpleLogger

Simple logger for rack.

## Installation

Add this line to your application's Gemfile:

    gem 'rack-simple_logger'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-simple_logger

## Usage

```ruby
require "rack/simple_logger"

use Rack::SimpleLogger
run RackApplication.new
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
