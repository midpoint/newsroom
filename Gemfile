source 'https://rubygems.org'

ruby '2.6.0'

gem 'rails', '~> 5.2.2'
gem 'puma', '~> 3.11'
gem 'pg'
gem 'sidekiq'
gem "sidekiq-cron"
gem 'excon'
gem "sentry-raven"

gem 'devise'
gem 'omniauth-github'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks', '~> 5'

gem 'sprockets-rails', '~> 3.2.1'
gem 'bootstrap', '~> 4.1.3'

gem 'jbuilder', '~> 2.5'

gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'bullet'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'

  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rspec-sidekiq'
end
