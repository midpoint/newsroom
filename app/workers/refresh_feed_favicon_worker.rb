# frozen_string_literal: true

class RefreshFeedFaviconWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_and_while_executing

  attr_reader :feed_id

  def perform(feed_id)
    @feed_id = feed_id

    feed.favicon = favicon.data
    feed.favicon_reloaded_at = Time.now
    feed.error = ""
    feed.save!
  rescue Excon::Error, Feedjira::NoParserAvailable => e
    feed.error = e
    feed.save!
  rescue StandardError => e
    feed.error = e
    feed.save!
    raise
  end

  private

  def feed
    @feed ||= Feed.find(feed_id)
  end

  def host
    @host ||= URI.parse(feed.url).host
  end

  def favicon
    @data ||= FaviconLoader.new(host)
  end
end
