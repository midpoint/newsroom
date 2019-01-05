class WelcomeController < ApplicationController
  def index
    @feeds = current_user.feeds
    @stories = current_user.stories.
      order("items.published_at DESC").
      includes(item: :feed)
  end
end
