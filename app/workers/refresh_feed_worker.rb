class RefreshFeedWorker
  include Sidekiq::Worker

  attr_reader :feed_id

  def perform(feed_id)
    @feed_id = feed_id

    feed.title = data.title
    feed.save
  end

  private

  def feed
    @feed ||= Feed.find(feed_id)
  end

  def data
    @data ||= FeedLoader.new(feed.url)
  end
end
