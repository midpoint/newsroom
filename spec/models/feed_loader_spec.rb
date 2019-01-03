require 'rails_helper'

RSpec.describe FeedLoader, type: :model do
  let(:host) { Faker::Internet.domain_name }
  let(:url)  { Faker::Internet.url(host) }
  subject    { described_class.new(url) }

  describe "with an atom feed" do
    before :each do
      Excon.stub(
        { host: host },
        { body: file_fixture("atom_feed.xml"), status: 200 }
      )
    end

    it "has the title set" do
      expect(subject.title).to eql("My Own Blog")
    end

    describe "items" do
      it "has items set" do
        expect(subject.items.length).to eql(2)
      end

      it "has items attributes set" do
        i = subject.items.first
        expect(i.guid).to eql("http://test.local/first-entry")
        expect(i.title).to eql("First entry")
        expect(i.url).to eql("http://test.local/first/")
        expect(i.published_at).to eql(Time.parse("2018-10-18T00:00:00Z"))
      end
    end
  end

  describe "with an rss feed" do
    before :each do
      Excon.stub(
        { host: host },
        { body: file_fixture("rss_feed.xml"), status: 200 }
      )
    end

    it "has the title set" do
      expect(subject.title).to eql("My Awesome Blog")
    end

    describe "items" do
      it "has items set" do
        expect(subject.items.length).to eql(2)
      end

      it "has items attributes set" do
        i = subject.items.first
        expect(i.guid).to eql("https://test.local/first/")
        expect(i.title).to eql("First entry")
        expect(i.url).to eql("https://test.local/first/")
        expect(i.published_at).to eql(Time.parse("Wed, 02 Jan 2019 05:00:00 -0000"))
      end
    end
  end
end
