# coding: utf-8

class TestApp
  def call(env)
    [
      200,
      {"Content-Type" => "text/plain"},
      ["Hello Rack Middleware"]
    ]
  end
end
