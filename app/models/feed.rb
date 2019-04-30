# frozen_string_literal: true

class Feed < ApplicationRecord
  has_many :items,
           dependent: :destroy
  has_many :subscriptions,
           dependent: :destroy

  validates :url,
            presence: true,
            uniqueness: true

  def error?
    !error.blank?
  end
end
