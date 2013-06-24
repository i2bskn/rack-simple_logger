# coding: utf-8

require "spec_helper"

describe Rack::SimpleLogger do
  let(:logger) {double("logger mock", class: "Logger").as_null_object}
  let(:app) {Rack::SimpleLogger.new(TestApp.new, log: logger)}

  describe "#initialize" do
    it "@app should be a TestApp object" do
      expect(app.instance_eval{@app}.is_a? TestApp).to be_true
    end

    it "@logger should be a LogPorxy object" do
      expect(app.instance_eval{@logger}.is_a? Rack::LogProxy).to be_true
    end

    it "@logger is STDOUT if not specified" do
      Rack::LogProxy.should_receive(:new).with(STDOUT)
      Rack::SimpleLogger.new(TestApp.new)
    end
  end

  describe "#call" do
    it "should call log method" do
      Rack::SimpleLogger.any_instance.should_receive(:log)
      get "/"
    end
  end

  describe "#log" do
    after {get "/"}

    it "should call LogProxy#write" do
      Rack::LogProxy.any_instance.should_receive(:write)
    end

    it "should call logger#info" do
      logger.should_receive(:info)
    end
  end
end