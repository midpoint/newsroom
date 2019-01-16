# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  render_views
  let(:story) { FactoryBot.create(:story) }
  let(:user)  { story.user }

  before do
    sign_in user
  end

  describe "new" do
    it "renders the template" do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe "create" do
    let!(:item) { FactoryBot.create(:item) }
    let(:url)   { Faker::Internet.url }

    it "creates a new item" do
      expect(SyncItemWorker).to receive(:perform_async)

      expect do
        post :create, params: { item: { url: url } }
      end.to change(Item, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(user.stories.map(&:url)).to include(url)
    end

    it "creates a new item in json" do
      expect(SyncItemWorker).to receive(:perform_async)

      Timecop.freeze(Time.now) do
        expect do
          post :create, params: { item: { url: url } }, format: :json
        end.to change(Item, :count).by(1)

        json = JSON.parse(response.body)
        item = Item.last
        expect(json).to include_json(
          id: item.id,
          feed_id: nil,
          title: nil,
          url: item.url,
          published_at: Time.now.utc.as_json,
        )
      end
    end

    it "subscribes to an existing item" do
      expect(SyncItemWorker).to receive(:perform_async).with(item.id)

      expect do
        post :create, params: { item: { url: item.url } }
      end.to change(Item, :count).by(0)

      expect(response).to redirect_to(root_path)
      expect(user.stories.map(&:url)).to include(item.url)
    end

    it "rerenders the new page" do
      expect(SyncItemWorker).not_to receive(:perform_async)

      post :create, params: { item: { url: "" } }
      expect(response).to have_http_status(:ok)
    end
  end
end
