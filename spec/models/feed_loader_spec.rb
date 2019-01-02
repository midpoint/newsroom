require 'rails_helper'

RSpec.describe FeedLoader, type: :model do
  let(:url) { Faker::Internet.url }
  subject   { described_class.new(url) }

  it "loads an atom feed" do
    Excon.stub({}, {body: file_fixture("atom_feed.xml"), status: 200})

    expect(subject.title).to eql("My Own Blog")
  end
end
