# frozen_string_literal: true

require "rails_helper"

describe TagHelper do
  let(:entries) { [
    FactoryBot.create(:subscription, tags: ["first", "second"]),
    FactoryBot.create(:subscription, tags: ["second", "third"])
  ] }

  describe "#group_by_tag" do

    it "groups entries by tags" do
      group = helper.group_by_tag(entries)

      expect(group.keys).to eql(["first", "second", "third"])
      expect(group["first"].map(&:id)).to eql([entries.first.id])
      expect(group["second"].map(&:id)).to eql([entries.first.id, entries.second.id])
      expect(group["third"].map(&:id)).to eql([entries.second.id])
    end
  end
end
