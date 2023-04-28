# Developing

To generate the Go code for the proto file, you need to install the Protobuf compiler (protoc), and install the Go protobuf and grpc protoc plugins, and then run protoc --go_out=. --go-grpc_out=. --proto_path ../proto ../proto/area_calculator.proto.

1. Create your proto file
2. `pact-plugin-cli -y install https://github.com/pactflow/pact-protobuf-plugin/releases/latest`
3. `protoc --go_out=. --go-grpc_out=. --proto_path ../proto ../proto/area_calculator.proto`
4.  `protoc --ruby_out=../lib --grpc_out=../lib ../proto/area_calculator.proto`
5.  `protoc --ruby_out=./lib --grpc_out=./lib ../proto/area_calculator.proto`
6.  grpc_tools_ruby_protoc -I ../../protos --ruby_out=../lib --grpc_out=../lib ../../protos/route_guide.proto



https://grpc.io/docs/languages/ruby/quickstart/#grpc-tools

1. `gem install grpc`
2. `gem install grpc-tools`
3. `git clone -b v1.50.0 --depth 1 --shallow-submodules https://github.com/grpc/grpc`
4. `rvm use 2.7.6`
5. `bundle install`
6. terminal 1 `ruby greeter_server.rb`
7. terminal 2 `ruby greeter_client.rb`
8. `grpc_tools_ruby_protoc -I ../protos --ruby_out=lib --grpc_out=lib ../protos/helloworld.proto`
9. `grpc_tools_ruby_protoc -I ./proto --ruby_out=area_calc_server --grpc_out=area_calc_server ./proto/area_calculator.proto`

## Publishing platform specific gems

https://rubygems.org/gems/nokogiri/versions
Nokigiri support the following

1.14.3 - April 11, 2023 java (9.56 MB)
1.14.3 - April 11, 2023 x86_64-linux (3.94 MB)
1.14.3 - April 11, 2023 (4.43 MB)
1.14.3 - April 11, 2023 x86-linux (4.13 MB)
1.14.3 - April 11, 2023 x86-mingw32 (5.88 MB)
1.14.3 - April 11, 2023 x86_64-darwin (6.53 MB)
1.14.3 - April 11, 2023 aarch64-linux (3.84 MB)
1.14.3 - April 11, 2023 arm64-darwin (6.35 MB)
1.14.3 - April 11, 2023 x64-mingw32 (3.19 MB)
1.14.3 - April 11, 2023 x64-mingw-ucrt (3.19 MB)
1.14.3 - April 11, 2023 arm-linux (3.3 MB)


### Gems we can build

x86_64-linux
x86_64-darwin
aarch64-linux
arm64-darwin