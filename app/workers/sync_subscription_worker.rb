# frozen_string_literal: true

class SyncSubscriptionWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_and_while_executing

  def perform(subscription_id)
    @subscription_id = subscription_id

    ActiveRecord::Base.transaction do
      stories.each do |story|
        story.update(tags: subscription.tags)
      end
    end
  end

  private

  def subscription
    @subscription ||= Subscription.find(@subscription_id)
  end

  def stories
    Story.
      where(user_id: subscription.user_id).
      where(feeds: { id: subscription.feed_id }).
      includes(item: :feed)
  end
end
