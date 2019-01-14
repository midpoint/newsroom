# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :feed

  validates :url,
    presence: true,
    uniqueness: { scope: :feed }
end
