require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  let(:github_id)    { SecureRandom.random_number }
  let(:username)     { "johndoe" }
  let(:email)        { "johndoe@example.com" }
  let(:github_token) { SecureRandom.uuid }

  describe "when login is successful" do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth::AuthHash.new({
        "provider" => "github",
        "uid" => github_id,
        "info" => {
          "email"    => email,
          "nickname" => username,
        },
        "credentials" => {
          "token" => github_token
        }
      })
    end

    describe "first login" do
      context "when email doesn't exist in the system" do
        before do
          get :github
        end

        it "should create the user" do
          user = User.where(github_id: github_id).first
          expect(user.username).to eq(username)
          expect(user.email).to eq(email)
          expect(user.github_token).to eq(github_token)
        end

        it { should be_user_signed_in }
        it { expect(response).to redirect_to root_path }
      end

      context "when email already exists in the system" do
        let!(:user) { User.create!(
          username: username,
          email: email,
          github_id: github_id,
          github_token: github_token,
        ) }

        before do
          get :github
        end

        it { should be_user_signed_in }
        it { expect(response).to redirect_to root_path }
      end
    end
  end

  describe "when login doesn't have the appropriate data" do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth::AuthHash.new({
        "provider" => "github"
      })
    end

    it "doesn't persist the user" do
      expect do
        get :github
      end.to change(User, :count).by(0)
    end

    it "should redirect back to root" do
      get :github
      expect(response).to redirect_to root_path
    end
  end
end
