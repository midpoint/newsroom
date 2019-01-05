require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  render_views

  describe "index" do
    let(:story) { FactoryBot.create(:story) }
    let(:user)  { story.user }

    describe "when logged in" do
      before do
        sign_in user
      end

      it "renders the template" do
        get :index
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
