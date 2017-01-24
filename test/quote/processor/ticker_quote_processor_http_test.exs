defmodule Ticker.Quote.Processor.HTTP.Test do
  use ExUnit.Case, async: false

  import Mock

  @good_body_200 {:ok, [%Ticker.Quote{c: "-1.55", c_fix: "-1.55", ccol: "chr", cp: "-0.19", cp_fix: "-0.19",
                                      e: "NASDAQ", id: "304466804484872", l: "806.36", l_cur: "806.36",
                                      l_fix: "806.36", lt: "Jan 12, 4:00PM EST", lt_dts: "2017-01-12T16:00:01Z",
                                      ltt: "4:00PM EST", pcls_fix: "807.91", s: "2", t: "GOOG"},
                        %Ticker.Quote{c: "-0.14", c_fix: "-0.14", ccol: "chr", cp: "-0.06", cp_fix: "-0.06",
                                      e: "NASDAQ", id: "12607212", l: "229.59", l_cur: "229.59",
                                      l_fix: "229.59", lt: "Jan 12, 4:00PM EST", lt_dts: "2017-01-12T16:00:01Z",
                                      ltt: "4:00PM EST", pcls_fix: "229.73", s: "2", t: "TSLA"}]}
  @bad_body_400 {:error, "Bad Request..."}
  @bad_body_404 {:error, "Not Found..."}

  def good_200 do
    {:ok,
     %HTTPoison.Response {
        body: "\n// [\n{\n\"id\": \"304466804484872\"\n,\"t\" : \"GOOG\"\n,\"e\" : \"NASDAQ\"\n,\"l\" : \"806.36\"\n,\"l_fix\" : \"806.36\"\n,\"l_cur\" : \"806.36\"\n,\"s\": \"2\"\n,\"ltt\":\"4:00PM EST\"\n,\"lt\" : \"Jan 12, 4:00PM EST\"\n,\"lt_dts\" : \"2017-01-12T16:00:01Z\"\n,\"c\" : \"-1.55\"\n,\"c_fix\" : \"-1.55\"\n,\"cp\" : \"-0.19\"\n,\"cp_fix\" : \"-0.19\"\n,\"ccol\" : \"chr\"\n,\"pcls_fix\" : \"807.91\"\n,\"el\": \"806.02\"\n,\"el_fix\": \"806.02\"\n,\"el_cur\": \"806.02\"\n,\"elt\" : \"Jan 12, 6:50PM EST\"\n,\"ec\" : \"-0.34\"\n,\"ec_fix\" : \"-0.34\"\n,\"ecp\" : \"-0.04\"\n,\"ecp_fix\" : \"-0.04\"\n,\"eccol\" : \"chr\"\n,\"div\" : \"\"\n,\"yld\" : \"\"\n}\n,{\n\"id\": \"12607212\"\n,\"t\" : \"TSLA\"\n,\"e\" : \"NASDAQ\"\n,\"l\" : \"229.59\"\n,\"l_fix\" : \"229.59\"\n,\"l_cur\" : \"229.59\"\n,\"s\": \"2\"\n,\"ltt\":\"4:00PM EST\"\n,\"lt\" : \"Jan 12, 4:00PM EST\"\n,\"lt_dts\" : \"2017-01-12T16:00:01Z\"\n,\"c\" : \"-0.14\"\n,\"c_fix\" : \"-0.14\"\n,\"cp\" : \"-0.06\"\n,\"cp_fix\" : \"-0.06\"\n,\"ccol\" : \"chr\"\n,\"pcls_fix\" : \"229.73\"\n,\"el\": \"229.10\"\n,\"el_fix\": \"229.10\"\n,\"el_cur\": \"229.10\"\n,\"elt\" : \"Jan 12, 7:59PM EST\"\n,\"ec\" : \"-0.49\"\n,\"ec_fix\" : \"-0.49\"\n,\"ecp\" : \"-0.21\"\n,\"ecp_fix\" : \"-0.21\"\n,\"eccol\" : \"chr\"\n,\"div\" : \"\"\n,\"yld\" : \"\"\n}\n]\n",
        headers: [{"Content-Type", "text/html; charset=ISO-8859-1"},
          {"Date", "Fri, 13 Jan 2017 04:38:30 GMT"}, {"Pragma", "no-cache"},
          {"Expires", "Fri, 01 Jan 1990 00:00:00 GMT"},
          {"Cache-Control", "no-cache, no-store, must-revalidate, proxy-revalidate"},
          {"X-UA-Compatible", "IE=EmulateIE7"}, {"X-Content-Type-Options", "nosniff"},
          {"X-Frame-Options", "SAMEORIGIN"}, {"X-XSS-Protection", "1; mode=block"},
          {"Server", "GSE"},
          {"Set-Cookie",
          "SC=RV=:ED=us; expires=Sat, 15-Jul-2017 04:38:30 GMT; path=/finance; domain=.google.com"},
          {"Accept-Ranges", "none"}, {"Vary", "Accept-Encoding"},
          {"Transfer-Encoding", "chunked"}],
        status_code: 200
      }
    }
  end

  def bad_400 do
    {:ok,
     %HTTPoison.Response{
        body: "httpserver.cc: Response Code 400\n",
        headers: [{"Content-Type", "text/html; charset=ISO-8859-1"},
          {"X-Content-Type-Options", "nosniff"},
          {"Date", "Fri, 13 Jan 2017 13:42:27 GMT"},
          {"Expires", "Fri, 13 Jan 2017 13:42:27 GMT"},
          {"Cache-Control", "private, max-age=0"}, {"X-Frame-Options", "SAMEORIGIN"},
          {"X-XSS-Protection", "1; mode=block"}, {"Server", "GSE"},
          {"Accept-Ranges", "none"}, {"Vary", "Accept-Encoding"},
          {"Transfer-Encoding", "chunked"}],
        status_code: 400
      }
    }
  end

  def bad_404 do
    {:ok,
     %HTTPoison.Response{
        body: "BLAH",
        headers: [{"Content-Type", "text/html; charset=ISO-8859-1"},
          {"X-Content-Type-Options", "nosniff"},
          {"Date", "Fri, 13 Jan 2017 13:42:27 GMT"},
          {"Expires", "Fri, 13 Jan 2017 13:42:27 GMT"},
          {"Cache-Control", "private, max-age=0"}, {"X-Frame-Options", "SAMEORIGIN"},
          {"X-XSS-Protection", "1; mode=block"}, {"Server", "GSE"},
          {"Accept-Ranges", "none"}, {"Vary", "Accept-Encoding"},
          {"Transfer-Encoding", "chunked"}],
        status_code: 404
      }
    }
  end

  test "200" do
    with_mock HTTPoison, [get: fn(_url) -> good_200() end] do
      body = Ticker.Quote.Processor.HTTP.process(["GOOG", "TSLA"])
      assert called HTTPoison.get("http://finance.google.com/finance/info?client=ig&q=NASDAQ%3AGOOG%2CTSLA")
      assert body == @good_body_200
    end
  end

  test "400" do
    with_mock HTTPoison, [get: fn(_url) -> bad_400() end] do
      body = Ticker.Quote.Processor.HTTP.process(["***"])
      assert called HTTPoison.get("http://finance.google.com/finance/info?client=ig&q=NASDAQ%3A***")
      assert body == @bad_body_400
    end
  end

  test "404" do
    with_mock HTTPoison, [get: fn(_url) -> bad_404() end] do
      body = Ticker.Quote.Processor.HTTP.process(["***"])
      assert called HTTPoison.get("http://finance.google.com/finance/info?client=ig&q=NASDAQ%3A***")
      assert body == @bad_body_404
    end
  end

end
