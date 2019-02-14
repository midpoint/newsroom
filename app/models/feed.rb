# frozen_string_literal: true

class Feed < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :items,
    dependent: :destroy

  validates :url,
    presence: true,
    uniqueness: true

  def error?
    !error.blank?
  end
end
