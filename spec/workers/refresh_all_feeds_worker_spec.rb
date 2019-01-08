# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefreshAllFeedsWorker, type: :worker do
  let!(:feed) { FactoryBot.create(:feed) }

  it "runs" do
    expect(RefreshFeedWorker).to receive(:perform_async).with(feed.id)
    run!
  end

  private

  def run!
    described_class.new.perform
  end
end
