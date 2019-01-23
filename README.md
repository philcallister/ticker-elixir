[![Build Status](https://travis-ci.org/philcallister/ticker-elixir.svg?branch=elixir_1.8_iex)](https://travis-ci.org/philcallister/ticker-elixir)
[![Coverage Status](https://coveralls.io/repos/github/philcallister/ticker-elixir/badge.svg?branch=elixir_1.8_iex)](https://coveralls.io/github/philcallister/ticker-elixir?branch=elixir_1.8_iex)

# ticker-elixir

**ticker-elixir** is an example Elixir OTP app which periodically pulls quotes for configured symbols. In this example, quotes are
pulled from the IEX Group, TOPS API. Additionly, quotes can be simulated (the current default). Retrieved quotes are stored within individual symbol GenServers.
These quotes are then rolled up into time-frame intervals using ETS tables, stored within additional GenServers, all supervised by OTP.

To broadcast quote/time-frame information, callbacks can be configured to notify of updates. These callbacks are how the
**ticker-phoenix** application captures quotes/time-frames and publishes them to Phoenix channels.

While currently not implemented at this time, it might be interesting to build an adapter layer to configure this OTP app to consume
different quote endpoints.

A **HUGE** missing piece to this puzzle is that historical data is currently only stored within ETS. It would be a lot of fun to wire this into Cassandra, a perfect solution for time-based historical data.

To see the **ticker-elixir** app in action, head over to
- [ticker-phoenix](https://github.com/philcallister/ticker-phoenix) Elixir Phoenix app
- [ticker-react](https://github.com/philcallister/ticker-react) React app

To run the three apps togther, follow the startup instructions for both **ticker-phoenix** & **ticker-react**. This app, **ticker-elixir**,  will be included within **ticker-phoenix**

##### Example screenshot of the three applications being used together
![Stock Ticker](/screen-shot.gif?raw=true "Stock Ticker Example")

## Environment

The sample was developed using the following 

- Elixir 1.8.0
- OTP 20

## Setup

Clone Repo
```bash
git clone https://github.com/philcallister/ticker.git
```

Dependencies
```bash
mix deps.get
```
```bash
mix deps.compile
```

## Run It

Start the server

```bash
mix ticker.server
```

OR within ```iex```

```bash
iex -S mix ticker.server
```

## Installation within OTP app 

1. Add `ticker` to your list of dependencies in `mix.exs`:

	```elixir
	def deps do
		[{:ticker, git: "https://github.com/philcallister/ticker-elixir.git"}]
	end
	```

2. Ensure `ticker` is started before your application:

	```elixir
	def application do
		[applications: [:ticker]]
	end
	```

## License

[MIT License](http://www.opensource.org/licenses/MIT)

**Free Software, Hell Yeah!**
