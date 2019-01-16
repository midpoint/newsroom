# frozen_string_literal: true

class FeedsController < ApplicationController
  ENTRIES_PER_PAGE = 20

  def show
    @feed = Feed.find(params[:id])
    @feeds = current_user.feeds
    @stories = current_user.stories.
               where("items.feed_id = ?", params[:id]).
               order("items.published_at DESC").
               includes(item: :feed).
               page((params[:page] || 1).to_i).per(ENTRIES_PER_PAGE)
  end

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.where(url: feed_params[:url]).first_or_create

    if @feed.persisted?
      current_user.feeds << @feed
      RefreshFeedWorker.perform_async(@feed.id)
    end

    respond_with @feed, location: -> { root_path }
  end

  private

  def feed_params
    params.require(:feed).permit(:url)
  end
end
