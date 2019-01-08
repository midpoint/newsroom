# frozen_string_literal: true

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

  describe "with a successful load" do
    before :each do
      Excon.stub(
        { host: host },
        { body: file_fixture("rss_feed.xml").read, status: 200 }
      )
    end

    it "has the title set" do
      expect(subject.title).to eql("My Awesome Blog")
    end

    describe "items" do
      it "has items set" do
        expect(subject.entries.length).to eql(2)
      end

      it "has items attributes set" do
        i = subject.entries.first
        expect(i.entry_id).to eql("https://test.local/first/")
        expect(i.title).to eql("First entry")
        expect(i.url).to eql("https://test.local/first/")
        expect(i.published).to eql(Time.parse("Wed, 02 Jan 2019 05:00:00 -0000"))
      end
    end
  end
end
