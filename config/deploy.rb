# config valid only for current version of Capistrano
lock "3.10.0"

# Keep sensitive deployment informatino out of the repo. As seen on:
# https://github.com/AyuntamientoMadrid/transparencia/blob/master/config/deploy.rb
def deploy_param(key)
  @deploy_keys ||= YAML.load_file('config/deploy.yml')[fetch(:stage).to_s]
  @deploy_keys.fetch(key.to_s, 'undefined')
end

# Deploy settings
set :application, "makigas"
set :deploy_to, deploy_param(:deploy_to)
set :repo_url, deploy_param(:repo_url)

namespace :deploy do
  task :restart do
    on roles(:app) do
      within current_path do
        execute :kill, '-SIGUSR2', '`cat tmp/pids/puma.pid`'
      end
    end
  end
end

# Shared settings
append :linked_files, ".env"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Misc settings
after 'deploy:finishing', 'deploy:cleanup'
after 'deploy:finishing', 'sitemap:refresh'
after 'deploy:finishing', 'deploy:restart'
