# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    feed

    title        { Faker::Movies::BackToTheFuture.quote }
    url          { Faker::Internet.url }
    published_at { Faker::Date.backward(14)  }
  end
end
