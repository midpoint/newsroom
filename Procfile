web: bundle exec puma -C config/puma.rb
release: bundle exec rails db:migrate
worker: bundle exec sidekiq --require ./config/sidekiq.rb
