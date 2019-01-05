class Story < ApplicationRecord
  belongs_to :user
  belongs_to :item

  delegate :feed,         to: :item
  delegate :guid,         to: :item
  delegate :title,        to: :item
  delegate :url,          to: :item
  delegate :published_at, to: :item
end
