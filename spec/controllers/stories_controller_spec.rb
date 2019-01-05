require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  render_views

  describe "read" do
    let(:story) { FactoryBot.create(:story) }
    let(:user)  { story.user }

    before do
      sign_in user
    end

    it "marks the story as read" do
      expect(story).not_to be_read
      post :read, params: { id: story.id }
      expect(response).to have_http_status(:ok)
      expect(story.reload).to be_read
    end
  end
end
