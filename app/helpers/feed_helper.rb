module FeedHelper

  def feed_title(feed)
    if feed.title.blank?
      u = URI.parse(feed.url)
      return u.host
    end
    return feed.title
  end
end
