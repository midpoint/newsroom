class FeedsController < ApplicationController
  before_action :authenticate_user!

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
