source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

gem 'has_secure_token'

gem 'mandrill-api', require: 'mandrill'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]


gem 'annotate', '~> 2.6.5'

gem 'date_validator', '~> 0.7.1'

# Utilizado para criação de threads
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

# Utilizado para autenticação de usuários
gem 'devise'

# gem 'thin'
# gem 'private_pub'

gem "bullet", :group => "development"

gem 'rack-mini-profiler'

gem 'omniauth-facebook'
gem "koala", "~> 2.0"

gem 'jquery-fileupload-rails', "0.4.1"
gem "paperclip", "~> 4.2"

gem "pagseguro-oficial", '=2.0.5'

# Tracking de exceções lançadas na plataforma
gem 'rollbar', '~> 1.5.1'
# Para notificar Rollbar quando deploy for feito
gem 'mina-rollbar', require: false
gem 'mina-sidekiq', require: false


group :test, :development do
  gem 'byebug'
end

group :test do
  gem 'shoulda' # Adiciona métodos simples para testes
  gem 'minitest-reporters' # Cria output dos testes colorido
  gem "minitest-rails"
  gem "minitest-rails-capybara"
  gem 'mocha'
  gem 'selenium-webdriver'
  gem 'simplecov', :require => false
  gem 'ruby-prof'
  gem 'vcr'
  gem 'fakeweb'
  gem 'capybara-mechanize'
end