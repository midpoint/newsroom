# frozen_string_literal: true

class Subscription < ApplicationRecord
  include Taggable

  belongs_to :user
  belongs_to :feed

  validates :feed_id,
    presence: true,
    uniqueness: { scope: :user_id }

  delegate :title,   to: :feed
  delegate :url,     to: :feed
  delegate :favicon, to: :feed
end
