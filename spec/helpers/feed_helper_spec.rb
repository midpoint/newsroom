# frozen_string_literal: true

require "rails_helper"

describe FeedHelper do
  let(:feed) { FactoryBot.create(:feed) }

  describe "#feed_title" do
    it "returns the title" do
      expect(helper.feed_title(feed)).to eql(feed.title)
    end

    it "returns a blank string for a nil feed" do
      expect(helper.feed_title(nil)).to eql("")
    end

    describe "when the feed has no title" do
      let(:feed) { FactoryBot.create(:feed, title: "") }

      it "returns the URI's host" do
        u = URI.parse(feed.url)
        expect(helper.feed_title(feed)).to eql(u.host)
      end
    end
  end

  describe "#feed_favicon" do
    it "returns the feed favicon" do
      expect(helper.feed_favicon(feed)).to eql("<i class=\"fe fe-feed\"></i>")
    end

    it "returns the book favicon for a nil feed" do
      expect(helper.feed_favicon(nil)).to eql("<i class=\"fe fe-book\"></i>")
    end

    it "returns the specified favicon" do
      feed.favicon = "my favicon"
      expect(helper.feed_favicon(feed)).to eql("<img class=\"favicon\" src=\"data:image/vnd.microsoft.icon;base64,my favicon\" />")
    end

  end
end
