class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :feed

  delegate :title,   to: :feed
  delegate :url,     to: :feed
  delegate :favicon, to: :feed
end
