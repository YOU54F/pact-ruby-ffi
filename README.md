# PactFfi

Ruby spike gem, to show interactions with the Pact Rust FFI methods.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pact-ffi'
```

And then execute:

    bundle

Or install it yourself as:

    gem install pact-ffi

## Usage

TODO: Write usage instructions here

## Pre-Reqs

- Ruby
  - This gem is compatible with `3.0`

- FFI libraries for your current platform - run `./script/download-libs.sh` to download
- If testing the protobuf plugin
  - `2.7` for protobuf/grpc example
    - See https://grpc.io/docs/languages/ruby/quickstart/ for steps
    - See `examples/proto-ruby/README.md` for notes
    - ruby-grpc is not currently, on m1 hardware for the `pact-protobuf-plugin` example
    - Have the pact-protobuf plugin available
      - Run `pact-plugin-cli -y install https://github.com/pactflow/pact-protobuf-plugin/releases/latest`
## Development

- run `bin/setup` or `bundle install` to install dependencies
- run `./script/download-libs.sh` to download FFI libraries for your current platform
- run `rake spec` to run tests

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/[USERNAME>]/pact-ffi. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PactFfi project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pact-ffi/blob/master/CODE_OF_CONDUCT.md).
