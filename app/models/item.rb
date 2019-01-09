# frozen_string_literal: true

class Item < ApplicationRecord

  belongs_to :feed

  validates :guid,
    presence: true,
    uniqueness: { scope: :feed }

  validates :url,
    presence: true
end
