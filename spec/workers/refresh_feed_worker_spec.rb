# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefreshFeedWorker, type: :worker do
  let(:feed)   { FactoryBot.create(:feed) }
  let(:title)  { feed.title }
  let(:loader) { OpenStruct.new(title: title, entries: entries) }
  let(:entries)  { [
    OpenStruct.new(
      entry_id: SecureRandom.uuid,
      title: Faker::DrWho.quote,
      url: Faker::Internet.url,
      published: DateTime.now
    ),
    OpenStruct.new(
      entry_id: SecureRandom.uuid,
      title: Faker::DrWho.quote,
      url: Faker::Internet.url,
      published: DateTime.now
    )
  ] }

  describe "when loading the feed succeeds" do
    before do
      expect(FeedLoader).to receive(:new).with(feed.url) { loader }
    end

    it "runs" do
      run!
    end

    it "removes any error from the feed" do
      feed.update_attribute(:error, "some error")
      run!
      expect(feed.reload.error).to eql("")
    end

    it "adds new items" do
      expect do
        run!
      end.to change(feed.reload.items, :count).from(0).to(2)

      item = feed.items.first
      expect(item.guid).to eql(entries.first.entry_id)
      expect(item.title).to eql(entries.first.title)
      expect(item.url).to eql(entries.first.url)
      expect(item.published_at.to_i).to eql(entries.first.published.to_i)
    end

    describe "stories" do
      let(:user) { FactoryBot.create(:user) }

      before do
        user.feeds << feed
      end

      it "create a story for the user" do
        expect do
          run!
        end.to change { user.stories.reload.count }.from(0).to(2)
        expect(user.stories.first.item).to eql(feed.items.first)
      end

      it "handles duplicate stories" do
        entries.each do |e|
          i = FactoryBot.create(:item, feed: feed, guid: e.entry_id)
          FactoryBot.create(:story, user: user, item: i)
        end

        expect do
          run!
        end.to change { user.reload.stories.count }.by(0)
      end
    end

    describe "when the title has changed" do
      let(:title) { Faker::StarWars.quote }

      it "updates the model" do
        expect do
          run!
        end.to change{ feed.reload.title }.to(title)
      end
    end

    describe "when an item's content has changed" do
      it "updates the item" do
        FactoryBot.create(:item, feed: feed, guid: entries.first.entry_id)

        expect do
          run!
        end.to change(feed.reload.items, :count).by(1)

        item = feed.items.first
        expect(item.guid).to eql(entries.first.entry_id)
        expect(item.title).to eql(entries.first.title)
        expect(item.url).to eql(entries.first.url)
        expect(item.published_at.to_i).to eql(entries.first.published.to_i)
      end
    end

    describe "refresh the favicon" do

      describe "when the favicon was never reloaded" do
        let(:feed) { FactoryBot.create(:feed, favicon_reloaded_at: nil) }

        it "reloads the favicon" do
          expect(RefreshFeedFaviconWorker).to receive(:perform_async).with(feed.id) { true }
          run!
        end
      end

      describe "when the favicon was last reloaded over a week ago" do
        let(:feed) { FactoryBot.create(:feed, favicon_reloaded_at: 2.weeks.ago) }

        it "reloads the favicon" do
          expect(RefreshFeedFaviconWorker).to receive(:perform_async).with(feed.id) { true }
          run!
        end
      end

      describe "when the favicon was reloaded recently" do
        let(:feed) { FactoryBot.create(:feed, favicon_reloaded_at: 1.hour.ago) }

        it "reloads the favicon" do
          expect(RefreshFeedFaviconWorker).not_to receive(:perform_async)
          run!
        end
      end
    end
  end

  describe "when loading the feed failed" do
    before do
      expect(FeedLoader).to receive(:new).with(feed.url).and_raise(Excon::Error.new)
    end

    it "updates the feed to the specified error" do
      run!
      expect(feed.reload.error).to eql("Excon::Error")
    end
  end

  private

  def run!
    described_class.new.perform(feed.id)
  end
end
