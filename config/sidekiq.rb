# frozen_string_literal: true

require "bundler"
Bundler.require(:default, ENV["RACK_ENV"])

Sidekiq.configure_client do |config|
  config.redis = { size: 3 }
end
Sidekiq.configure_server do |config|
  #no redis settings
end
