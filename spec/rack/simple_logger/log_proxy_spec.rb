# coding: utf-8

require "spec_helper"

describe Rack::LogProxy do
  let(:logger_mock) {double("logger mock", class: "Logger").as_null_object}
  let(:io_mock) {double("IO mock", class: "IO").as_null_object}
  let(:mongo_mock) {double("mongo mock", class: "Mongo::Collection").as_null_object}
  let(:custom_mock) {double("custom logger mock", class: "Other").as_null_object}


  describe "#initialize" do
    context "with Logger object" do
      let(:proxy) {Rack::LogProxy.new(logger_mock)}

      it "@logger should be a specified logger" do
        expect(proxy.instance_eval{@logger}).to eq(logger_mock)
      end

      it "@log_type should be a :logger" do
        expect(proxy.instance_eval{@log_type}).to eq(:logger)
      end

      it "should call logger_formatter method" do
        Rack::LogProxy.any_instance.should_receive(:logger_formatter)
        expect{proxy}.not_to raise_error
      end
    end

    context "with String object" do
      before {::Logger.should_receive(:new).with("str").and_return(logger_mock)}
      let(:proxy) {Rack::LogProxy.new("str")}

      it "create new logger object" do
        expect(proxy.instance_eval{@logger}).to eq(logger_mock)
      end

      it "@log_type should be a :logger" do
        expect(proxy.instance_eval{@log_type}).to eq(:logger)
      end

      it "should call logger_formatter method" do
        Rack::LogProxy.any_instance.should_receive(:logger_formatter)
        expect{proxy}.not_to raise_error
      end
    end

    context "with IO object" do
      before {::Logger.should_receive(:new).with(io_mock).and_return(logger_mock)}
      let(:proxy) {Rack::LogProxy.new(io_mock)}

      it "create new logger object" do
        expect(proxy.instance_eval{@logger}).to eq(logger_mock)
      end

      it "@log_type should be a :logger" do
        expect(proxy.instance_eval{@log_type}).to eq(:logger)
      end

      it "should call logger_formatter method" do
        Rack::LogProxy.any_instance.should_receive(:logger_formatter)
        expect{proxy}.not_to raise_error
      end
    end

    context "with Mongo::Connection object" do
      let(:proxy) {Rack::LogProxy.new(mongo_mock)}

      it "@logger should be a connection of mongodb" do
        expect(proxy.instance_eval{@logger}).to eq(mongo_mock)
      end

      it "@log_type should be a :mongo" do
        expect(proxy.instance_eval{@log_type}).to eq(:mongo)
      end

      it "should not call logger_formatter method" do
        Rack::LogProxy.any_instance.should_not_receive(:logger_formatter)
        expect{proxy}.not_to raise_error
      end
    end

    context "with custom logger object" do
      let(:proxy) {Rack::LogProxy.new(custom_mock)}

      it "@logger should be a custom logger object" do
        expect(proxy.instance_eval{@logger}).to eq(custom_mock)
      end

      it "@log_type should be a :mongo" do
        expect(proxy.instance_eval{@log_type}).to eq(:other)
      end

      it "should not call logger_formatter method" do
        Rack::LogProxy.any_instance.should_not_receive(:logger_formatter)
        expect{proxy}.not_to raise_error
      end
    end
  end

  describe "#write" do
    it "dispatch to write_logger" do
      Rack::LogProxy.any_instance.should_receive(:write_logger)
      expect{Rack::LogProxy.new(logger_mock).write(k: "v")}.not_to raise_error
    end

    it "dispatch to write_mongo" do
      Rack::LogProxy.any_instance.should_receive(:write_mongo)
      expect{Rack::LogProxy.new(mongo_mock).write(k: "v")}.not_to raise_error
    end

    it "dispatch to write_other" do
      Rack::LogProxy.any_instance.should_receive(:write_other)
      expect{Rack::LogProxy.new(custom_mock).write(k: "v")}.not_to raise_error
    end
  end

  describe "#write_logger" do
    it "output ltsv format log" do
      proxy = Rack::LogProxy.new(logger_mock)
      logger_mock.should_receive(:info).with("k1:v1\tk2:v2")
      expect{proxy.write(k1: "v1", k2: "v2")}.not_to raise_error
    end
  end

  describe "#write_mongo" do
    it "insert log of Hash" do
      proxy = Rack::LogProxy.new(mongo_mock)
      mongo_mock.should_receive(:insert).with(k: "v")
      expect{proxy.write(k: "v")}.not_to raise_error
    end
  end

  describe "#write_other" do
    it "write custom format log" do
      proxy = Rack::LogProxy.new(custom_mock)
      custom_mock.should_receive(:write).with(k: "v")
      expect{proxy.write(k: "v")}.not_to raise_error
    end
  end

  describe "#logger_formatter" do
    let(:proxy) {Rack::LogProxy.new(STDOUT)}

    it "should call logger_formatter method" do
      Rack::LogProxy.any_instance.should_receive(:logger_formatter)
      expect{proxy}.not_to raise_error
    end

    it "format is the only message" do
      expect(
        proxy.instance_eval{@logger}.formatter.call(
          "severity",
          "datetime",
          "progname",
          "msg"
        )
      ).to eq("msg\n")
    end
  end
end