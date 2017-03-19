# Dockerfile for makigas
FROM ruby:2.3.3

# Software required to run the application
# build-essential: required for building some gem natives
# nodejs: required for precompiling assets
# libpq-dev: required for the pg gem
# imagemagick: runtime requirement for processing uploaded images
RUN apt-get update -qq && apt-get install -y build-essential nodejs libpq-dev imagemagick

# Initialize working directory for our application.
RUN mkdir /usr/src/makigas
WORKDIR /usr/src/makigas

# Install Ruby dependencies in a different stage than copying application data.
# Smoother caches and ultimately less time waiting for building images.
ADD Gemfile /usr/src/makigas/Gemfile
ADD Gemfile.lock /usr/src/makigas/Gemfile.lock
RUN bundle install

# Copy the rest of the application
ADD config/database.yml.docker /usr/src/makigas/config/database.yml
ADD config/secrets.yml.docker /usr/src/makigas/config/secrets.yml
ADD . /usr/src/makigas

# Run the application
VOLUME ["/usr/src/makigas/public"]
CMD ["bin/rails", "server", "-b", "0.0.0.0"]