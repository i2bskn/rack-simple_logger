# coding: utf-8

require "spec_helper"

describe Rack::SimpleLogger do
  let(:logger) {double("logger mock", class: "Logger").as_null_object}
  let(:filter) {double("filter mock")}
  let(:app) {Rack::SimpleLogger.new(TestApp.new, log: logger)}

  describe "#initialize" do
    it "@app should be a TestApp object" do
      expect(app.instance_eval{@app}.is_a? TestApp).to be_true
    end

    it "@logger should be a LogPorxy object" do
      expect(app.instance_eval{@logger}.is_a? Rack::LogProxy).to be_true
    end

    it "@logger should be a STDOUT if not specified" do
      Rack::LogProxy.should_receive(:new).with(STDOUT)
      Rack::SimpleLogger.new(TestApp.new)
    end

    it "@filter should be a LogFilter object" do
      expect(app.instance_eval{@filter}.is_a? Rack::LogFilter).to be_true
    end

    it "@filter should be a specified filter" do
      app = Rack::SimpleLogger.new(TestApp.new, log: logger, filter: filter)
      expect(app.instance_eval{@filter}).to eq(filter)
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

    it "should call LogFilter#pass" do
      Rack::LogFilter.any_instance.should_receive(:pass).and_return({a: 1})
    end

    it "should call LogProxy#write" do
      Rack::LogProxy.any_instance.should_receive(:write)
    end

    it "should call logger#info" do
      logger.should_receive(:info)
    end
  end
end