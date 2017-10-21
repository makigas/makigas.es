# This Dockerfile compiles the makigas web application. It can be
# used to deploy a static image to a production server or to
# develop or test the application in a standalone application
# without having to install the stuff.

FROM ruby:2.4.1-alpine
MAINTAINER Dani Rodríguez <dani@danirod.es>

# Install dependencies.
RUN apk add --update alpine-sdk postgresql-dev imagemagick nodejs tzdata && \
    npm install -g yarn

# Initializes the working directory.
RUN mkdir /makigas
WORKDIR /makigas

# Install dependencies
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
ADD package.json package.json
ADD docker/database.yml config/database.yml
ADD yarn.lock yarn.lock
RUN bundle install && yarn

# Remaining files.
ADD . .
