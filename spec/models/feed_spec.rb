# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feed, type: :model do
  subject { FactoryBot.build(:feed) }

  it "has items" do
    expect(subject.items.count).to eq(0)
  end
end
