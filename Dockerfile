# This Dockerfile compiles the makigas web application. It can be
# used to deploy a static image to a production server or to
# develop or test the application in a standalone application
# without having to install the stuff.

FROM ruby:2.4.1
MAINTAINER Dani Rodríguez <dani@danirod.es>

# Installs required dependencies. Node.js 6.x repository is added.
# Also, every other backend and JavaScript dependency is installed.
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y build-essential libpq-dev imagemagick nodejs && \
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
