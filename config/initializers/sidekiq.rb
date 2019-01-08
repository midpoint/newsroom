# frozen_string_literal: true

require 'sidekiq-cron'

Sidekiq::Cron::Job.load_from_array [
  {
    'name'  => 'refresh all feeds',
    'class' => 'RefreshAllFeedsWorker',
    'cron'  => '*/10 * * * *'
  },
]
