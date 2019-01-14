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
      expect do
        post :create, params: { item: { url: url } }
      end.to change(Item, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(user.stories.map(&:url)).to include(url)
    end

    it "subscribes to an existing item" do
      expect do
        post :create, params: { item: { url: item.url } }
      end.to change(Item, :count).by(0)

      expect(response).to redirect_to(root_path)
      expect(user.stories.map(&:url)).to include(item.url)
    end

    it "rerenders the new page" do
      post :create, params: { item: { url: "" } }
      expect(response).to have_http_status(:ok)
    end
  end
end
