# frozen_string_literal: true

module FeedHelper

  def feed_title(feed)
    if feed.title.blank?
      u = URI.parse(feed.url)
      return u.host
    end
    return feed.title
  end

  def feed_favicon(feed)
    return image_tag("data:image/vnd.microsoft.icon;base64,#{feed.favicon}", class: "favicon") unless feed.favicon.blank?

    return content_tag(:i, "", class: "fe fe-feed")
  end
end
