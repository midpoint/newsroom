# frozen_string_literal: true

class FeedsController < ApplicationController
  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.where(url: feed_params[:url]).first_or_create

    if @feed.persisted?
      Subscription.create!(user: current_user, feed: @feed)
      RefreshFeedWorker.perform_async(@feed.id)
    end

    respond_with @feed, location: -> { root_path }
  end

  private

  def feed_params
    params.require(:feed).permit(:url)
  end
end
