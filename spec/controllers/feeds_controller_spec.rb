require 'rails_helper'

RSpec.describe FeedsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

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
    let!(:feed) { FactoryBot.create(:feed) }
    let(:url)  { Faker::Internet.url }

    it "creates a new feed" do
      expect(RefreshFeedWorker).to receive(:perform_async)

      expect do
        post :create, params: { feed: { url: url } }
      end.to change(Feed, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(user.feeds.length).to eq(1)
      expect(user.feeds.map(&:url)).to include(url)
    end

    it "subscribes to an existing feed" do
      expect(RefreshFeedWorker).to receive(:perform_async).with(feed.id)

      expect do
        post :create, params: { feed: { url: feed.url } }
      end.to change(Feed, :count).by(0)

      expect(response).to redirect_to(root_path)
      expect(user.feeds.length).to eq(1)
      expect(user.feeds.map(&:url)).to include(feed.url)
    end
  end
end
