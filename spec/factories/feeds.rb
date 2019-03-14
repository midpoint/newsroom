# frozen_string_literal: true

FactoryBot.define do
  factory :feed do
    title { Faker::Movies::HarryPotter.character }
    url { Faker::Internet.url }
    favicon_reloaded_at { Time.now }
  end
end
