# coding: utf-8

module Rack
  class LogProxy
    def initialize(logger)
      case logger.class.to_s
      when "Logger"
        @logger = logger
        @log_type = :logger
      when "String", "IO"
        @logger = ::Logger.new(logger)
        @log_type = :logger
      when "Mongo::Collection"
        @logger = logger
        @log_type = :mongo
      else
        @logger = logger
        @log_type = :other
      end

      logger_formatter if @log_type == :logger
    end

    def logger_formatter
      @logger.formatter = Proc.new do |severity, datetime, progname, msg|
        "#{msg}\n"
      end
    end

    def write(log_hash)
      send("write_#{@log_type}", log_hash)
    end

    def write_logger(log_hash)
      @logger.info log_hash.map{|k,v| [k, v].join(":")}.join("\t")
    end

    def write_mongo(log_hash)
      @logger.insert log_hash
    end

    def write_other(log_hash)
      @logger.write log_hash
    end
  end
end
