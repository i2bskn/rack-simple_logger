# coding: utf-8

require "spec_helper"

describe Rack::LogFilter do
  let(:filter) {Rack::LogFilter.new}
  let(:status) {200}
  let(:began_at) {Time.now}

  let(:env) do
    {
      "REMOTE_ADDR"=>"127.0.0.1",
      "REQUEST_METHOD"=>"GET",
      "PATH_INFO"=>"/login",
      "QUERY_STRING"=>"",
     "HTTP_USER_AGENT"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36"
    }
  end

  let(:header) do
    {"Content-Length" => 256}
  end

  describe "#pass" do
    it "should return Hash object" do
      expect(filter.pass(env, status, header, began_at).is_a? Hash).to be_true 
    end

    it "size should be 10 items" do
      expect(filter.pass(env, status, header, began_at).size).to eq(10)
    end
  end
end
