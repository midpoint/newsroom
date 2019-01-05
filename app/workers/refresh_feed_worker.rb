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
        i = feed.items.where(guid: item.entry_id || item.url).first_or_initialize
        i.title = item.title
        i.url = item.url
        i.published_at = item.published
        i.save!

        feed.users.each do |user|
          user.stories.first_or_create!(item_id: i.id)
        end
      end
    end
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

  def data
    @data ||= FeedLoader.new(feed.url)
  end
end
