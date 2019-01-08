# frozen_string_literal: true

class Item < ApplicationRecord

  belongs_to :feed

  validates :guid,
    presence: true,
    uniqueness: true

  validates :url,
    presence: true
end
