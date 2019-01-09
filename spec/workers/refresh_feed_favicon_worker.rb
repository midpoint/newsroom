# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefreshFeedFaviconWorker, type: :worker do
  let(:feed)    { FactoryBot.create(:feed) }
  let(:host)    { URI.parse(feed.url).host }
  let(:favicon) { "my favicon content" }
  let(:loader)  { OpenStruct.new(data: favicon) }

  describe "when loading the favicon succeeds" do
    before do
      expect(FaviconLoader).to receive(:new).with(host) { loader }
    end

    it "runs" do
      run!
    end

    it "removes any error from the feed" do
      feed.update_attribute(:error, "some error")
      run!
      expect(feed.reload.error).to eql("")
    end

    it "updates the favicon and reloaded time" do
      run!

      expect(feed.reload.favicon).to eql(favicon)
      expect(feed.favicon_reloaded_at.to_i).to eql(Time.now.to_i)
    end
  end

  describe "when loading the feed failed" do
    before do
      expect(FaviconLoader).to receive(:new).with(host).and_raise(Excon::Error.new)
    end

    it "updates the feed to the specified error" do
      run!
      expect(feed.reload.error).to eql("Excon::Error")
    end
  end

  private

  def run!
    Sidekiq::Testing.inline! do
      described_class.perform_async(feed.id)
    end
  end
end
