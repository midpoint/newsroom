# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :feed,
    optional: true

  validates :url,
    presence: true,
    uniqueness: { scope: :feed }
end
