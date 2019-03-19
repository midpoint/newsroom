# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  def new
    @subscription = current_user.subscriptions.new(feed: Feed.new)
  end

  def create
    data = subscription_params
    feed = Feed.where(url: data.delete(:url)).first_or_create
    @subscription = current_user.subscriptions.create(data.merge(feed: feed))

    if @subscription.persisted?
      RefreshFeedWorker.perform_async(feed.id)
    end

    respond_with @subscription, location: -> { root_path }
  end

  private

  def subscription_params
    params.require(:subscription).permit(:url)
  end
end