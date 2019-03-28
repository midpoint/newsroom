# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do

  describe "#find_all" do
    let(:user)          { FactoryBot.create(:user) }
    let!(:subscription) { FactoryBot.create(:subscription, user: user) }
    let!(:story)        { FactoryBot.create(:story, user: user) }

    it "finds all tags" do
      tags = Tag.find_all(user)
      expect(tags).to eql(subscription.tags + story.tags)
    end
  end
end
