# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Request, type: :model do
  let(:host) { Faker::Internet.domain_name }
  let(:path) { "/#{SecureRandom.uuid}" }
  let(:url)  { Faker::Internet.url(host, path) }

  describe "#get" do
    let(:status) { 200 }

    before do
      Excon.stub(
        { host: host, path: path },
        { body: "\o/", status: status }
      )
    end

    it "delegates to excon" do
      req = described_class.get(url)
      expect(req.body).to eql("\o/")
      expect(req.status).to eql(200)
    end

    describe "with an error" do
      let(:status) { 503 }

      it "raises" do
        expect do
          described_class.get(url)
        end.to raise_error(Excon::Error)
      end
    end
  end
end
