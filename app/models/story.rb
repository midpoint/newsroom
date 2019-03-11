# frozen_string_literal: true

class Story < ApplicationRecord
  include Taggable

  belongs_to :user
  belongs_to :item

  delegate :feed,         to: :item
  delegate :title,        to: :item
  delegate :url,          to: :item
  delegate :published_at, to: :item

  def read?
    !read_at.nil?
  end
end
