#!/bin/sh
set -e
rm -vf tmp/pids/server.pid

export RAILS_LOG_TO_STDOUT=true
export RAILS_SERVE_STATIC_FILES=true

bin/rails db:migrate
exec bin/rails server -b 0.0.0.0
