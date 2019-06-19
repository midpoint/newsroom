# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefreshAllFeedsWorker, type: :worker do
  let!(:feed) { FactoryBot.create(:feed) }

  it "runs" do
    FactoryBot.create(:subscription, feed: feed)
    expect(RefreshFeedWorker).to receive(:perform_async).with(feed.id)
    run!
  end

  it "doesn't refresh a feed without a subscription" do
    expect(RefreshFeedWorker).not_to receive(:perform_async)
    run!
  end

  private

  def run!
    described_class.new.perform
  end
end
