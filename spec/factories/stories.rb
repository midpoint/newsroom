# frozen_string_literal: true

FactoryBot.define do
  factory :story do
    user
    item
    tags { [Faker::Artist.name, Faker::WorldOfWarcraft.hero] }
  end
end
