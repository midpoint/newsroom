require 'rails_helper'

RSpec.describe Item, type: :model do
  subject { FactoryBot.build(:item) }

  it "has a feed" do
    expect(subject.feed).to be_a(Feed)
  end
end
