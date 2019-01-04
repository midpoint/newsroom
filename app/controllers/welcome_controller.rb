class WelcomeController < ApplicationController
  def index
    @feeds = current_user.feeds
    @items = current_user.items.
      order(published_at: :desc).
      includes(:feed)
  end
end
