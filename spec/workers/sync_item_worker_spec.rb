# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SyncItemWorker, type: :worker do
  let(:item)   { FactoryBot.create(:item) }
  let(:title)  { item.title }
  let(:loader) { OpenStruct.new(title: title) }

  it "runs" do
    run!
  end

  describe "when the title has changed" do
    let(:title) { Faker::StarWars.quote }

    it "does not update the model" do
      expect do
        run!
      end.not_to change(item.reload, :title)
    end
  end

  describe "when the item has no feed" do
    let(:item) { FactoryBot.create(:item, feed: nil) }

    before do
      expect(ItemLoader).to receive(:new).with(item.url) { loader }
    end

    describe "when the title has changed" do
      let(:title) { Faker::StarWars.quote }

      it "updates the model" do
        expect do
          run!
        end.to change{ item.reload.title }.to(title)
      end
    end
  end

  describe "when loading the item failed" do
    let(:item) { FactoryBot.create(:item, feed: nil) }

    before do
      expect(ItemLoader).to receive(:new).with(item.url).and_raise("foobar")
    end

    it "raises an error" do
      expect do
        run!
      end.to raise_error("foobar")
    end
  end

  private

  def run!
    described_class.new.perform(item.id)
  end
end
