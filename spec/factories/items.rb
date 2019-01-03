FactoryBot.define do
  factory :item do
    feed

    guid { SecureRandom.uuid }
    title { Faker::BackToTheFuture.quote }
    url { Faker::Internet.url }
    published_at { Faker::Date.backward(14)  }
  end
end
