# frozen_string_literal: true

class SubscriptionsController < ApplicationController

  def index
    @subscriptions = current_user.subscriptions
  end

  def new
    @subscription = current_user.subscriptions.new(feed: Feed.new)
  end

  def edit
    @subscription = current_user.subscriptions.find(params[:id])
    render :new
  end

  def create
    data = subscription_params
    feed = Feed.where(url: data.delete(:url)).first_or_create
    @subscription = current_user.subscriptions.create(data.merge(feed: feed))

    if @subscription.persisted?
      RefreshFeedWorker.perform_async(feed.id)
    end

    respond_with @subscription, location: -> { subscriptions_path }
  end

  def update
    data = subscription_params
    data.delete(:url)

    @subscription = current_user.subscriptions.find(params[:id])
    @subscription.update(subscription_params)
    SyncSubscriptionWorker.perform_async(@subscription.id)

    respond_with @subscription, location: -> { subscriptions_path }
  end

  private

  def subscription_params
    params.require(:subscription).permit(:url, :tags)
  end
end
