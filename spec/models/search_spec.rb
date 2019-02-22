# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search, type: :model do
  let(:query) { "" }
  let(:user) { FactoryBot.build(:user) }
  subject { described_class.new(query: query, user: user) }
  let!(:stories) { [
    FactoryBot.create(:story, user: user, read: false),
    FactoryBot.create(:story, user: user, read: true)
  ] }

  it "succeeds with an empty query" do
    d = subject.run
    expect(d.count).to eql(2)
  end

  describe "read" do
    describe "fetching unread stories" do
      let(:query) { "read:false" }

      it "succeeds" do
        d = subject.run
        expect(d.count).to eql(1)
        expect(d.first.read).to be(false)
      end
    end

    describe "fetching read stories" do
      let(:query) { "read:true" }

      it "succeeds" do
        d = subject.run
        expect(d.count).to eql(1)
        expect(d.first.read).to be(true)
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

end
