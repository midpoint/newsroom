# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username     { Faker::Internet.username }
    email        { Faker::Internet.email }
    github_id    { SecureRandom.uuid }
    github_token { SecureRandom.uuid }
  end
end
