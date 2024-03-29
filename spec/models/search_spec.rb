# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search, type: :model do
  let(:query) { "" }
  let(:user) { FactoryBot.build(:user) }
  subject { described_class.new(query: query, user: user) }
  let!(:stories) { [
    FactoryBot.create(:story, user: user),
    FactoryBot.create(:story, user: user, read_at: Time.now)
  ] }

  it "succeeds with an empty query" do
    d = subject.run
    expect(d.count).to eql(2)
  end

  describe "with params and search" do
    let(:query) { "read:false #{stories.first.title}" }
    let!(:stories) { [
      FactoryBot.create(:story, user: user),
      FactoryBot.create(:story, user: user)
    ] }

    it "succeeds" do
      d = subject.run
      expect(d.count).to eql(1)
    end
  end

  describe "read" do
    describe "fetching unread stories" do
      let(:query) { "read:false" }

      it "succeeds" do
        d = subject.run
        expect(d.count).to eql(1)
        expect(d.first).not_to be_read
      end
    end

    describe "fetching read stories" do
      let(:query) { "read:true" }

      it "succeeds" do
        d = subject.run
        expect(d.count).to eql(1)
        expect(d.first).to be_read
      end
    end
  end

  describe "feed" do
    let(:query) { "feed:#{stories.first.feed.id}" }

    it "searches by feed" do
      d = subject.run
      expect(d.count).to eql(1)
      expect(d.first.feed).to eql(stories.first.feed)
    end
  end

  describe "tag" do
    let(:query) { "tag:#{stories.first.tags.first}" }

    it "searches by feed" do
      d = subject.run
      expect(d.count).to eql(1)
      expect(d.first.feed).to eql(stories.first.feed)
    end

    describe "with a none search" do
      let(:query) { "tag:none" }

      it "searches for stories without a tag" do
        story = FactoryBot.create(:story, user: user, tags: [])

        d = subject.run
        expect(d.count).to eql(1)
        expect(d.first.feed).to eql(story.feed)
      end
    end
  end
end
