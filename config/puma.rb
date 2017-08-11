# This is the default Puma configuration optimized for development
# If you are trying to run Puma in a production environment, please
# use puma.production.rb (such as bin/puma -C puma.production.rb).

threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

port ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }
