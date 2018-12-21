FactoryBot.define do
  factory :feed do
    title { Faker::HarryPotter.character }
    url { Faker::Internet.url }
  end
end
