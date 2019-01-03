class RefreshFeedWorker
  include Sidekiq::Worker

  attr_reader :feed_id

  def perform(feed_id)
    @feed_id = feed_id

    Feed.transaction do
      feed.title = data.title
      feed.error = ""
      feed.save!

      data.items.each do |item|
        i = feed.items.where(guid: item.guid).first_or_initialize
        i.title = item.title
        i.url = item.url
        i.published_at = item.published_at
        i.save!
      end
    end
  rescue StandardError => e
    feed.error = e
    feed.save!
  end

  private

  def feed
    @feed ||= Feed.find(feed_id)
  end

  def data
    @data ||= FeedLoader.new(feed.url)
  end
end
