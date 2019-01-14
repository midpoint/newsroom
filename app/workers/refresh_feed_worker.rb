# frozen_string_literal: true

class RefreshFeedWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_and_while_executing

  attr_reader :feed_id

  def perform(feed_id)
    @feed_id = feed_id

    Feed.transaction do
      feed.title = data.title
      feed.error = ""
      feed.save!

      data.entries.each do |item|
        i = feed.items.where(url: item.url).first_or_initialize
        i.title = item.title
        i.url = item.url
        i.published_at = item.published
        i.save!

        feed.users.each do |user|
          user.stories.where(item_id: i.id).first_or_create!
        end
      end
    end

    if feed.favicon_reloaded_at.nil? || feed.favicon_reloaded_at < 1.week.ago
      RefreshFeedFaviconWorker.perform_async(feed.id)
    end
  rescue Excon::Error, Feedjira::NoParserAvailable => e
    feed.error = e
    feed.save!
  rescue StandardError => e
    feed.error = e
    feed.save!
    raise if Rails.env.test?
  end

  private

  def feed
    @feed ||= Feed.find(feed_id)
  end

  def data
    @data ||= FeedLoader.new(feed.url)
  end
end
