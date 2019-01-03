class FeedsController < ApplicationController
  def show
    @feed = Feed.find(params[:id])
    @feeds = current_user.feeds
  end

  def new
    @feed = Feed.new
  end

  def create
    feed = Feed.where(url: feed_params[:url]).first_or_create

    if feed.persisted?
      current_user.feeds << feed
      RefreshFeedWorker.perform_async(feed.id)

      redirect_to root_path
    else
      render :new
    end
  end

  private

  def feed_params
    params.require(:feed).permit(:url)
  end
end
