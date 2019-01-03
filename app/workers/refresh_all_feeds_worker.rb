class RefreshAllFeedsWorker
  include Sidekiq::Worker

  attr_reader :feed_id

  def perform
    feeds.each do |feed|
      RefreshFeedWorker.perform_async(feed.id)
    end
  end

  private

  def feeds
    @feeds ||= Feed.all
  end
end
