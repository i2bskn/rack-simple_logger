# coding: utf-8

require "logger"

require "rack/simple_logger/version"
require "rack/simple_logger/log_proxy"
require "rack/simple_logger/log_filter"

module Rack
  class SimpleLogger
    def initialize(app, options={})
      @logger = LogProxy.new(options.fetch(:log, STDOUT))
      @filter = options.fetch(:filter, LogFilter.new)
      @app = app
    end

    def call(env)
      began_at = Time.now
      status, header, body = @app.call(env)
      log(@filter.pass(env, status, header, began_at))
      [status, header, body]
    end

    private
    def log(log_hash)
      @logger.write(log_hash)
    end
  end
end
