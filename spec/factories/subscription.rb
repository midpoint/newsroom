# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    user
    feed
    tags { [Faker::Superhero.name, Faker::Games::Pokemon.name] }
  end
end
