# frozen_string_literal: true

FactoryBot.define do
  factory :feed do
    title { Faker::HarryPotter.character }
    url { Faker::Internet.url }
  end
end
