# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  render_views
  let!(:subscription) { FactoryBot.create(:subscription) }
  let(:feed)          { subscription.feed }
  let(:user)          { subscription.user }

  before do
    sign_in user
  end

  describe "new" do
    it "renders the template" do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe "edit" do

    it "renders the template" do
      get :edit, params: { id: subscription.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "create" do
    let!(:feed) { FactoryBot.create(:feed) }
    let(:url)   { Faker::Internet.url }

    it "creates a subscription with a new feed" do
      expect(RefreshFeedWorker).to receive(:perform_async)

      expect do
        expect do
          post :create, params: { subscription: { url: url, tags: "hello, world" } }
        end.to change(user.subscriptions, :count).by(1)
      end.to change(Feed, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(user.subscriptions.map(&:url)).to include(url)
      expect(user.subscriptions.map(&:tags)).to include(["hello", "world"])
    end

    it "creates a subscription with an existing feed" do
      expect(RefreshFeedWorker).to receive(:perform_async).with(feed.id)

      expect do
        expect do
          post :create, params: { subscription: { url: feed.url, tags: "hello, world" } }
        end.to change(user.subscriptions, :count).by(1)
      end.to change(Feed, :count).by(0)

      expect(response).to redirect_to(root_path)
      expect(user.subscriptions.map(&:url)).to include(feed.url)
    end

    it "rerenders the new page" do
      expect(RefreshFeedWorker).not_to receive(:perform_async)

      post :create, params: { subscription: { url: "" } }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "update" do
    let(:url)  { Faker::Internet.url }

    it "updates a subscription" do
      expect do
        patch :update, params: {
          id: subscription.id,
          subscription: {
            tags: "hello, world"
          }
        }
      end.to change(Subscription, :count).by(0)

      expect(response).to redirect_to(root_path)
      expect(user.subscriptions.length).to eq(1)
      expect(user.subscriptions.map(&:url)).to include(feed.url)
      expect(user.subscriptions.map(&:tags)).to include(["hello", "world"])
    end

    it "cannot update the subscription's url" do
      expect do
        patch :update, params: {
          id: subscription.id,
          subscription: {
            tags: "hello, world"
          }
        }
      end.to change(Feed, :count).by(0)

      expect(response).to redirect_to(root_path)
      expect(user.subscriptions.length).to eq(1)
      expect(user.subscriptions.map(&:url)).to include(feed.url)
      expect(user.subscriptions.map(&:tags)).to include(["hello", "world"])
    end
  end
end
