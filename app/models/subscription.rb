# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :feed
  has_and_belongs_to_many :tags

  validates :feed_id,
    presence: true,
    uniqueness: { scope: :user_id }

  delegate :title,   to: :feed
  delegate :url,     to: :feed
  delegate :favicon, to: :feed
end
