# frozen_string_literal: true

class User < ApplicationRecord
  devise :rememberable,
    :omniauthable, omniauth_providers: [:github]

  has_many :subscriptions
  has_many :stories

  validates :username, presence: true
  validates :email, presence: true

  validates :github_id, presence: true
  validates :github_token, presence: true
end
