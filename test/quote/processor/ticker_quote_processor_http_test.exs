defmodule Ticker.Quote.Processor.HTTP.Test do
  use ExUnit.Case, async: false

  import Mock

  @good_body_200 {:ok, [%Ticker.Quote{symbol: "GOOG", marketPercent: 0.03406, bidSize: 0,
                                      bidPrice: 0, askSize: 200, askPrice: 983.98, volume: 27292,
                                      lastSalePrice: 983.56, lastSaleSize: 50,
                                      lastSaleTime: 1496683852096, lastUpdated: 1496683920111},
                        %Ticker.Quote{symbol: "TSLA", marketPercent: 0.01556, bidSize: 100,
                                      bidPrice: 344.4, askSize: 0, askPrice: 0, volume: 63888,
                                      lastSalePrice: 344.38, lastSaleSize: 100,
                                      lastSaleTime: 1496683923830, lastUpdated: 1496683926824}]}
  @bad_body_400 {:error, "Bad Request..."}

  def good_200 do
    {:ok,
     %HTTPoison.Response {
        body: ~s([{"symbol":"GOOG","marketPercent":0.03406,"bidSize":0,"bidPrice":0,"askSize":200,"askPrice":983.98,"volume":27292,"lastSalePrice":983.56,"lastSaleSize":50,"lastSaleTime":1496683852096,"lastUpdated":1496683920111},
                  {"symbol":"TSLA","marketPercent":0.01556,"bidSize":100,"bidPrice":344.4,"askSize":0,"askPrice":0,"volume":63888,"lastSalePrice":344.38,"lastSaleSize":100,"lastSaleTime":1496683923830,"lastUpdated":1496683926824}]),
        headers: [{"Server", "nginx"},
                  {"Date", "Mon, 05 Jun 2017 12:07:50 GMT"},
                  {"Connection", "keep-alive"},
                  {"Content-Security-Policy", "default-src 'self'; child-src 'none'; object-src 'none'; style-src 'self' 'unsafe-inline'; font-src data:; connect-src 'self' https://auth.iextrading.com wss://iextrading.com wss://tops.iextrading.com; script-src 'self';"},
                  {"X-Content-Security-Policy", "default-src 'self'; child-src 'none'; object-src 'none'; style-src 'self' 'unsafe-inline'; font-src data:; connect-src 'self' https://auth.iextrading.com wss://iextrading.com wss://tops.iextrading.com; script-src 'self';"},
                  {"Frame-Options", "deny"},
                  {"X-Frame-Options", "deny"},
                  {"X-Content-Type-Options", "nosniff"},
                  {"ETag", "W/\"158-Ys73+jt9TG6lcEkCX0Z1cg\""},
                  {"Expires", "Mon, 05 Jun 2017 12:07:50 GMT"},
                  {"Cache-Control", "max-age=0"},
                  {"Cache-Control", "no-cache"},
                  {"Strict-Transport-Security", "max-age=15768000"},
                  {"Access-Control-Allow-Origin", "*"},
                  {"Access-Control-Allow-Credentials", "true"},
                  {"Access-Control-Allow-Methods", "GET"},
                  {"Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept"}],
        status_code: 200
      }
    }
  end

  def bad_400 do
    {:ok,
     %HTTPoison.Response{
        body: ~s({"error": "child \"symbols\" fails because [\"symbols\" is not allowed to be empty]"}"),
        headers: [{"Server", "nginx"},
                  {"Date", "Mon, 05 Jun 2017 23:03:08 GMT"},
                  {"Content-Type", "application/json; charset=utf-8"},
                  {"Content-Length", "84"},
                  {"Connection", "keep-alive"},
                  {"Content-Security-Policy", "default-src 'self'; child-src 'none'; object-src 'none'; style-src 'self' 'unsafe-inline'; font-src data:; connect-src 'self' https://auth.iextrading.com wss://iextrading.com wss://tops.iextrading.com; script-src 'self';"},
                  {"X-Content-Security-Policy", "default-src 'self'; child-src 'none'; object-src 'none'; style-src 'self' 'unsafe-inline'; font-src data:; connect-src 'self' https://auth.iextrading.com wss://iextrading.com wss://tops.iextrading.com; script-src 'self';"},
                  {"Frame-Options", "deny"},
                  {"X-Frame-Options", "deny"},
                  {"ETag", "W/\"54-emmcsVPiDVvFJPgdd5OAcg\""}],
        status_code: 400
      }
    }
  end

  test "200" do
    with_mock HTTPoison, [get: fn(_url) -> good_200() end] do
      body = Ticker.Quote.Processor.HTTP.process(["GOOG", "TSLA"])
      assert called HTTPoison.get("https://api.iextrading.com/1.0/tops?symbols=GOOG%2CTSLA")
      assert body == @good_body_200
    end
  end

  test "400" do
    with_mock HTTPoison, [get: fn(_url) -> bad_400() end] do
      body = Ticker.Quote.Processor.HTTP.process([])
      assert called HTTPoison.get("https://api.iextrading.com/1.0/tops?symbols=")
      assert body == @bad_body_400
    end
  end

end
