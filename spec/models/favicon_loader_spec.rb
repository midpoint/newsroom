# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FaviconLoader, type: :model do
  let(:host) { Faker::Internet.domain_name }
  subject    { described_class.new(host) }

  describe "with errors" do
    before do
      Excon.stub(
        { host: host },
        { body: "An error occured", status: 503 }
      )
    end

    it "is nil" do
      expect(subject.data).to be_nil
    end
  end

  describe "with an home which doesn't contain a favicon rel" do
    before do
      Excon.stub(
        { host: host, path: "/" },
        { body: "", status: 200 }
      )
    end

    describe "with an existing favicon.ico" do
      before do
        Excon.stub(
          { host: host, path: "/favicon.ico" },
          { body: file_fixture("favicon.ico").read, status: 200 }
        )
      end

      it "returns the base64 data" do
        expect(subject.data).to eql(Base64.encode64(file_fixture("favicon.ico").read))
      end
    end

    describe "with a redirect" do
      before do
        Excon.stub(
          { host: host, path: "/favicon.ico" },
          { body: "", status: 301, headers: { "Location" => "http://#{host}/my_favicon.ico" } }
        )

        Excon.stub(
          { host: host, path: "/my_favicon.ico" },
          { body: file_fixture("favicon.ico").read, status: 200 }
        )
      end

      it "returns the base64 data" do
        expect(subject.data).to eql(Base64.encode64(file_fixture("favicon.ico").read))
      end
    end

    describe "with a missing favicon.ico" do
      before do
        Excon.stub(
          { host: host, path: "/favicon.ico" },
          { body: "Not Found", status: 404 }
        )
      end

      it "returns the base64 data" do
        expect(subject.data).to be_nil
      end
    end
  end

  describe "with an home which contains a favicon rel" do
    before do
      Excon.stub(
        { host: host, path: "/" },
        { body: file_fixture("html/with_favicon.html").read, status: 200 }
      )
      Excon.stub(
        { host: host, path: "/my_favicon.ico" },
        { body: file_fixture("favicon.ico").read, status: 200 }
      )
    end


    it "returns the base64 data" do
      expect(subject.data).to eql(Base64.encode64(file_fixture("favicon.ico").read))
    end
  end

  describe "with an home which redirects" do
    before do
      Excon.stub(
        { host: host, path: "/" },
        { body: "", status: 301, headers: { "Location" => "http://#{host}/home" } }
      )
      Excon.stub(
        { host: host, path: "/home" },
        { body: file_fixture("html/with_favicon.html").read, status: 200 }
      )
      Excon.stub(
        { host: host, path: "/my_favicon.ico" },
        { body: file_fixture("favicon.ico").read, status: 200 }
      )
    end


    it "returns the base64 data" do
      expect(subject.data).to eql(Base64.encode64(file_fixture("favicon.ico").read))
    end
  end

  describe "make link absolute" do
    it "handle absolute links with the host" do
      expect(subject.send(:make_link_absolute, "https://example.com/foobar")).to eql("https://example.com/foobar")
    end

    it "handle absolute links without the host" do
      expect(subject.send(:make_link_absolute, "/foobar")).to eql("http://#{host}/foobar")
    end

    it "handles relative links" do
      expect(subject.send(:make_link_absolute, "foobar")).to eql("http://#{host}/foobar")
    end
  end
end
