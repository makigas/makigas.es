workers ENV.fetch('WEB_CONCURRENCY') { 2 }
threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
threads threads_count, threads_count

preload_app!

environment ENV.fetch('RAILS_ENV') { 'development' }

bind 'unix://tmp/sockets/puma.sock'
pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  ActiveRecord::Base.establish_connection
end

plugin :tmp_restart
