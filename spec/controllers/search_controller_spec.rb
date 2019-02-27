# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  render_views

  describe "index" do
    let(:story) { FactoryBot.create(:story) }
    let(:user)  { story.user }

    describe "when logged in" do
      before do
        sign_in user
      end

      it "redirects to unread only" do
        get :index
        expect(response).to redirect_to(search_path(q: 'read:false'))
      end

      it "renders the template" do
        get :index, params: {q: 'read:false'}
        expect(response).to have_http_status(:ok)
      end

      it "renders stories in json" do
        get :index, params: {q: 'read:false'}, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    describe "when logged out" do
      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to(user_github_omniauth_authorize_path)
      end
    end
  end
end
