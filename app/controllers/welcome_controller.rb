class WelcomeController < ApplicationController
  def index
    @feeds = current_user.feeds
    @items = Item.
      where(feed_id: @feeds.map(&:id)).
      order(published_at: :desc).
      includes(:feed)
  end
end
