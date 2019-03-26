# frozen_string_literal: true

module Taggable
  extend ActiveSupport::Concern

  def tags=(value)
    value = value.split(",").map(&:strip) if value.is_a?(String)
    super(value.uniq)
  end
end
