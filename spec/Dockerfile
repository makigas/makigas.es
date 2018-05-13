# The Dockerfile used for testing makigas.

FROM ruby:2.4.4-alpine3.7
LABEL maintainer="dani@danirod.es"

# Install runtime dependencies
RUN apk --update add --no-cache tzdata file imagemagick nodejs build-base postgresql-dev xvfb chromium-chromedriver chromium

# Install JavaScript dependencies.
RUN npm install -g yarn

# Initializes the working directory.
RUN mkdir /makigas
WORKDIR /makigas

# Install dependencies
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
ADD package.json package.json
ADD docker/database.yml config/database.yml
ADD yarn.lock yarn.lock

# Install gems
RUN bundle install --no-cache && yarn install && yarn cache clean

# Remaining files.
ADD . .
CMD ["rspec"]
