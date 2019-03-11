# frozen_string_literal: true

module Taggable
  extend ActiveSupport::Concern

  def tags=(value)
    super(value.uniq)
  end
end
