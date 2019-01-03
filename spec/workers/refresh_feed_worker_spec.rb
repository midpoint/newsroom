require 'rails_helper'

RSpec.describe RefreshFeedWorker, type: :worker do
  let(:feed)   { FactoryBot.create(:feed) }
  let(:title)  { feed.title }
  let(:loader) { OpenStruct.new(title: title, items: items) }
  let(:items)  { [
    OpenStruct.new(
      guid: SecureRandom.uuid,
      title: Faker::DrWho.quote,
      url: Faker::Internet.url,
      published_at: DateTime.now
    )
  ] }

  before do
    expect(FeedLoader).to receive(:new).with(feed.url) { loader }
  end

  it "runs" do
    run!
  end

  it "adds new items" do
    expect do
      run!
    end.to change(feed.reload.items, :count).from(0).to(1)

    item = feed.items.first
    expect(item.guid).to eql(items.first.guid)
    expect(item.title).to eql(items.first.title)
    expect(item.url).to eql(items.first.url)
    expect(item.published_at.to_i).to eql(items.first.published_at.to_i)
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
      FactoryBot.create(:item, feed: feed, guid: items.first.guid)

      expect do
        run!
      end.to change(feed.reload.items, :count).by(0)

      item = feed.items.first
      expect(item.guid).to eql(items.first.guid)
      expect(item.title).to eql(items.first.title)
      expect(item.url).to eql(items.first.url)
      expect(item.published_at.to_i).to eql(items.first.published_at.to_i)
    end
  end

  private

  def run!
    Sidekiq::Testing.inline! do
      described_class.perform_async(feed.id)
    end
  end
end
