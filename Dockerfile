FROM ruby:3.0

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN gem update bundler
COPY . ./
# COPY Gemfile Gemfile.lock pact_ruby_ffi.gemspec ./
RUN bundle install


CMD ["./run.sh"]