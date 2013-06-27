# coding: utf-8

module Rack
  class LogFilter
    def pass(env, status, header, began_at)
      {
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
      }
    end
  end
end
