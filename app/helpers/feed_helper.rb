# frozen_string_literal: true

module FeedHelper

  def feed_title(feed)
    return "" if feed.nil?
    return URI.parse(feed.url).host if feed.title.blank?
    return feed.title
  end

  def feed_favicon(feed)
    return content_tag(:i, "", class: "fe fe-feed") if feed.nil? || feed.favicon.blank?
    return image_tag("data:image/vnd.microsoft.icon;base64,#{feed.favicon}", class: "favicon")
  end
end
