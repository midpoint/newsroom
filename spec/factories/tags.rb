# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    value { Faker::Superhero.name }
  end
end
