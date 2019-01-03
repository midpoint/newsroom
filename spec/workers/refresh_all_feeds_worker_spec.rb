require 'rails_helper'

RSpec.describe RefreshAllFeedsWorker, type: :worker do
  let!(:feed) { FactoryBot.create(:feed) }

  it "runs" do
    expect(RefreshFeedWorker).to receive(:perform_async).with(feed.id)
    run!
  end

  private

  def run!
    Sidekiq::Testing.inline! do
      described_class.perform_async
    end
  end
end
