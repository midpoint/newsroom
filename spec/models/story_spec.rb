# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Story, type: :model do
  subject { FactoryBot.build(:story) }

  describe "#read?" do
    it "is not read" do
      expect(subject).not_to be_read
    end

    it "is read" do
      subject.read_at = Time.now
      expect(subject).to be_read
    end
  end
end
