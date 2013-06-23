# coding: utf-8

require "logger"

require "rack/simple_logger/version"
require "rack/simple_logger/log_proxy"

module Rack
  class SimpleLogger
    def initialize(app, options={})
      options[:log] ||= STDOUT
      @logger = LogProxy.new(options[:log])
      @app = app
    end

    def call(env)
      began_at = Time.now
      status, header, body = @app.call(env)
      log(env, status, header, began_at)
      [status, header, body]
    end

    private
    def log(env, status, header, began_at)
      @logger.write(
        xff: env["HTTP_X_FORWARDED_FOR"] || "-",
        host: env["REMOTE_ADDR"],
        time: began_at.strftime("%Y-%m-%d %H:%M:%S"),
        method: env["REQUEST_METHOD"],
        path: env["PATH_INFO"],
        query_strings: env["QUERY_STRING"] || "-",
        status: status,
        ua: env["HTTP_USER_AGENT"],
        res_size: header["Content-Length"],
        app_time: Time.now - began_at
      )
    end
  end
end
