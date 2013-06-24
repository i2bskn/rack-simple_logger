require "simplecov"
require "coveralls"
Coveralls.wear!

# SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
SimpleCov.start do
  add_filter "spec"
  add_filter ".bundle"
end

require "rack/simple_logger"
require "rack/test"

Dir[File.expand_path("../support/*.rb", __FILE__)].each {|f| require f}

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.order = "random"
end
