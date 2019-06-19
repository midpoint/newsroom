# frozen_string_literal: true

class RefreshAllFeedsWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_and_while_executing

  attr_reader :feed_id

  def perform
    feeds.each do |feed|
      next if feed.subscriptions.empty?
      RefreshFeedWorker.perform_async(feed.id)
    end
  end

  private

  def feeds
    @feeds ||= Feed.all
  end
end
