FROM node:22-alpine3.20 AS node
FROM ruby:4.0.6-alpine
LABEL maintainer="dani@danirod.es"

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && \
    ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

# Build variables
ENV BUNDLE_PATH=/vendor/bundle
ENV NODE_ENV=production
ENV RAILS_ENV=production
ENV SECRET_KEY_BASE=placeholder

# Install dependencies.
RUN apk add --update --no-cache file postgresql-dev gcompat imagemagick \
    libffi yaml tzdata

# Initializes the working directory.
RUN mkdir /makigas
WORKDIR /makigas

# Install Ruby dependencies
ADD Gemfile Gemfile.lock /
RUN apk add --update --no-cache --virtual .build-deps \
      build-base libffi-dev yaml-dev && \
    gem install bundler:4.0.18 --clear-sources \
      --source https://beta.gem.coop && \
    bundle config set no-cache 'true' && \
    bundle config set without 'development test' && \
    bundle install && \
    rm -rf /vendor/bundle/ruby/4.0.0/cache/*.gem && \
    find /vendor/bundle/ruby/4.0.0/gems/ -name "*.[co]" -delete && \
    apk del .build-deps

ADD . .
# Avoid a Go garbage collector crash under QEMU's amd64 emulation.
RUN npm install --global pnpm@11.22.0 && \
    pnpm install --frozen-lockfile && \
    GOGC=off bin/rails assets:precompile && \
    rm -rf node_modules && \
    pnpm store prune && \
    npm uninstall --global pnpm && \
    rm -rf /usr/local/lib/node_modules /usr/local/bin/npm /usr/local/bin/npx

CMD ["docker/rails_start.sh"]
