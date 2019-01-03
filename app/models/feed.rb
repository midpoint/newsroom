class Feed < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :items

  validates :url,
    presence: true,
    uniqueness: true
end
