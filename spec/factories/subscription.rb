# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    user
    feed
  end
end
