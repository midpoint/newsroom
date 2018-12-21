class Feed < ApplicationRecord
  has_and_belongs_to_many :users

  validates :url,
    presence: true,
    uniqueness: true
end
