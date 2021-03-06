# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'alexandria'
set :repo_url, 'https://github.com/adammulligan/alexandria.git'

set :branch, "master"

set :linked_files, %w{config/aws.yml config/secrets.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      invoke 'deploy:stop'
      invoke 'deploy:start'
    end
  end
  after :publishing, :restart

  desc 'Start application'
  task :start do
    on roles(:web), in: :sequence, wait: 5 do
      execute "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D -E #{fetch(:rails_env)}"
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:web), in: :sequence, wait: 5 do
      execute "kill -s QUIT `cat #{shared_path}/tmp/pids/unicorn.pid` || :"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
