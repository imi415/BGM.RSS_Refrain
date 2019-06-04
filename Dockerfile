FROM ruby:alpine
RUN apk update && apk add --virtual build_temp build-base nodejs libxml2-dev sqlite-dev
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN gem install bundler:2.0.1
RUN bundle install -j2
RUN apk del build_temp && apk add sqlite-libs nodejs tzdata

COPY . /app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["/app/bin/rails", "server", "-b", "0.0.0.0"]
