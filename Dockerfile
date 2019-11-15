FROM ruby:2.6.3-alpine

RUN apk update && \
      apk add --no-cache build-base git postgresql-dev imagemagick
RUN apk add --no-cache imagemagick-dev=6.9.6.8-r1 --repository http://dl-3.alpinelinux.org/alpine/v3.5/main/

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY . /app

CMD ["bundle", "exec", "ruby", "bot.rb"]
