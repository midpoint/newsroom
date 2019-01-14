# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SyncItemWorker, type: :worker do
  let(:item)   { FactoryBot.create(:item) }
  let(:title)  { item.title }
  let(:loader) { OpenStruct.new(title: title) }

  describe "when loading the item succeeds" do
    before do
      expect(ItemLoader).to receive(:new).with(item.url) { loader }
    end

    it "runs" do
      run!
    end

    describe "when the title has changed" do
      let(:title) { Faker::StarWars.quote }

      it "updates the model" do
        expect do
          run!
        end.to change{ item.reload.title }.to(title)
      end
    end

    describe "when the item has a feed" do

      describe "when the title has changed" do
        let(:title) { Faker::StarWars.quote }

        it "does not update the model" do
          expect do
            run!
          end.not_to change(item, :reload, :title)
        end
      end
    end
  end

  describe "when loading the item failed" do
    before do
      expect(ItemLoader).to receive(:new).with(item.url).and_raise(Excon::Error.new)
    end

    it "raises an error" do
      expect do
      run!
      end.to raise_error(Excon::Error.new)
    end
  end

  private

  def run!
    described_class.new.perform(feed.id)
  end
end
