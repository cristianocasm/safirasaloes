require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'     # for rvm support. (http://rvm.io)
require 'mina/rollbar' # para notificar Rollbar quando deploy for feito
require 'mina_sidekiq/tasks'

set :domain, '45.55.237.28'
set :deploy_to, '/home/safira/'
set :repository, 'https://cristianocasm@bitbucket.org/cristianocasm/safirasaloes.git'
set :branch, 'master'
set :rollbar_access_token, "ec9ca75181824170925fa07796df7e56"
set :rails_env, 'production'
set :sidekiq_log, "#{deploy_to}#{shared_path}/log"
# Permite inserção da senha no terminal quando solicitado
set :term_mode, nil

# For system-wide RVM install.
set :rvm_path, '/usr/local/rvm/bin/rvm'

# Optional settings:
set :user, 'safira' # Username in the server to SSH to.
set :port, '5000' # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby-2.1.3p242]'
end

# Arquivos e pastas a serem compartilhadas entre as releases
set :shared_paths, ['config/database.yml', 'config/application.yml', 'log', 'public/assets/products']
# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  # Cria pasta "log" dentro de /home/rails/shared
  queue! %[mkdir -p "#{deploy_to}#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}#{shared_path}/log"]

  # Cria pasta "config" dentro de /home/rails/shared
  queue! %[mkdir -p "#{deploy_to}#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}#{shared_path}/config"]

  # sidekiq needs a place to store its pid file and log file
  queue! %[mkdir -p "#{deploy_to}#{shared_path}/pids/"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}#{shared_path}/pids"]

  # Cria pasta "products" dentro de /home/rails/shared/public/assets/products
  queue! %[mkdir -p "#{deploy_to}#{shared_path}/public/assets/products"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}#{shared_path}/public/assets/products"]

  # Cria arquivo "database.yml" dentro de /home/rails/shared/config
  queue! %[touch "#{deploy_to}#{shared_path}/config/database.yml"]

  # Cria arquivo "application.yml" dentro de /home/rails/shared/config
  queue! %[touch "#{deploy_to}#{shared_path}/config/application.yml"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'sidekiq:quiet' # stop accepting new workers
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'rollbar:notify'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}#{current_path}/tmp/"
      queue "touch #{deploy_to}#{current_path}/tmp/restart.txt"
      queue "sudo /etc/init.d/unicorn restart"
      invoke :'sidekiq:restart'
    end
  end
end

