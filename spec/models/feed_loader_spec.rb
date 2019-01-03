require 'rails_helper'

RSpec.describe FeedLoader, type: :model do
  let(:host) { Faker::Internet.domain_name }
  let(:url)  { Faker::Internet.url(host) }
  subject    { described_class.new(url) }

  describe "with an error" do
    before :each do
      Excon.stub(
        { host: host },
        { body: "An error occured", status: 503 }
      )
    end

    it "raises an exception" do
      expect do
        subject.title
      end.to raise_error(Excon::Error::ServiceUnavailable)
    end
  end

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

  describe "with an rdf feed" do
    before :each do
      Excon.stub(
        { host: host },
        { body: file_fixture("rdf_feed.xml"), status: 200 }
      )
    end

    it "has the title set" do
      expect(subject.title).to eql("An RDF Feed")
    end

    describe "items" do
      it "has items set" do
        expect(subject.items.length).to eql(2)
      end

      it "has items attributes set" do
        i = subject.items.first
        expect(i.guid).to eql("http://test.local/first-item")
        expect(i.title).to eql("First Item")
        expect(i.url).to eql("http://test.local/first-item")
        expect(i.published_at).to eql(Time.parse("2018-11-20T18:01:22+01:00"))
      end
    end
  end
end
