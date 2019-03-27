# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SyncSubscriptionWorker, type: :worker do
  let(:subscription) { FactoryBot.create(:subscription) }
  let(:user)         { subscription.user }
  let(:feed)         { subscription.feed }
  let(:item)         { FactoryBot.create(:item, feed: feed) }
  let(:story)        { FactoryBot.create(:story, user: user, item: item) }

  it "runs" do
    run!
  end

  it "updates the story's tags" do
    expect do
      run!
    end.to change { story.reload.tags }.to(subscription.tags)
  end

  describe "for a story belonging to a different user" do
    let(:story) { FactoryBot.create(:story, item: item) }

    it "does not change the tags" do
      expect do
        run!
      end.not_to(change { story.reload.tags })
    end
  end

  describe "for a story belonging to a different subscription" do
    let(:story) { FactoryBot.create(:story, user: user) }

    it "does not change the tags" do
      expect do
        run!
      end.not_to(change { story.reload.tags })
    end
  end

  private

  def run!
    described_class.new.perform(subscription.id)
  end
end
