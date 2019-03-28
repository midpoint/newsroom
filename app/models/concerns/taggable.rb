# frozen_string_literal: true

module Taggable
  extend ActiveSupport::Concern
  NO_TAG_TITLE = "none"

  def tags=(value)
    value = value.split(",").map(&:strip) if value.is_a?(String)
    value.delete(NO_TAG_TITLE)
    super(value.uniq)
  end

  def tags
    data = super
    data.empty? ? [NO_TAG_TITLE] : data
  end
end
