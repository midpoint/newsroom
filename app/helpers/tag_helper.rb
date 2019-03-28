# frozen_string_literal: true

module TagHelper

  def group_by_tag(entries)
    group = {}

    entries.each do |e|
      if e.tags.empty?
        group[Search::NO_TAG_TITLE] ||= []
        group[Search::NO_TAG_TITLE] << e
      else
        e.tags.each do |t|
          group[t] ||= []
          group[t] << e
        end
      end

    end

    group
  end
end
