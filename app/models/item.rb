# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :feed,
    optional: true
  has_many :stories,
    dependent: :destroy

  validates :url,
    presence: true,
    uniqueness: { scope: :feed }

  validates :published_at,
    presence: true
end
