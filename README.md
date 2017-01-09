[![Build Status](https://travis-ci.org/philcallister/ticker-elixir.svg?branch=master)](https://travis-ci.org/philcallister/ticker-elixir)
[![Coverage Status](https://coveralls.io/repos/github/philcallister/ticker-elixir/badge.svg?branch=master)](https://coveralls.io/github/philcallister/ticker-elixir?branch=master)

# ticker-elixir

**ticker-elixir** is an example Elixir OTP app which periodically pulls configured quotes from the (defunct but still available) Google Finance API and stores these quotes within symbol GenServers. A callback can be configured to notify when the quotes have been updated. While currently not implemented at this time, it might be interesting to build an adapter layer to configure the OTP app for different quote APIs.

To see the **ticker-elixir** app in action, head over to [ticker-phoenix](https://github.com/philcallister/ticker-phoenix) Elixir Phoenix app.

## Environment

The sample was developed using the following 

- Elixir 1.3.0
- OS X El Capitan (10.11)

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
