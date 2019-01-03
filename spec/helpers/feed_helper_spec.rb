require "rails_helper"

describe FeedHelper do
  let(:feed) { FactoryBot.create(:feed) }

  describe "#feed_title" do

    it "returns the title" do
      expect(helper.feed_title(feed)).to eql(feed.title)
    end

    describe "when the feed has no title" do
      let(:feed) { FactoryBot.create(:feed, title: "") }

      it "returns the URI's host" do
        u = URI.parse(feed.url)
        expect(helper.feed_title(feed)).to eql(u.host)
      end
    end
  end
end
