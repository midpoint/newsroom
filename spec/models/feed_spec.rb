# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feed, type: :model do
  subject { FactoryBot.build(:feed) }

  it "has items" do
    expect(subject.items.count).to eq(0)
  end

  describe "error?" do
    it "does not have an error" do
      expect(subject.error?).to be(false)
    end

    it "has an error" do
      subject.error = "some error"
      expect(subject.error?).to be(true)
    end
  end
end
