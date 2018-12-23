require 'rails_helper'
RSpec.describe RefreshFeedWorker, type: :worker do
  let(:feed)   { FactoryBot.create(:feed) }
  let(:title)  { feed.title }
  let(:loader) { OpenStruct.new(title: title) }

  before do
    FeedLoader.stub(:new).with(feed.url) { loader }
  end

  it "runs" do
    run!
  end

  describe "when the title has changed" do
    let(:title) { Faker::StarWars.quote }

    it "updated the model" do
      expect do
        run!
      end.to change{ feed.reload.title }.to(title)
    end
  end

  private

  def run!
    Sidekiq::Testing.inline! do
      described_class.perform_async(feed.id)
    end
  end
end
