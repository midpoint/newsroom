require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe "index" do
    it "renders the template" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
