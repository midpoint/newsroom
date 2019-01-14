# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemLoader, type: :model do
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
        { body: file_fixture("html/with_favicon.html").read, status: 200 }
      )
    end

    it "has the title set" do
      expect(subject.title).to eql("Test")
    end
  end
end
