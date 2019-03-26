# frozen_string_literal: true

module TagHelper
  NO_TAG_TITLE = "No Tags"

  def group_by_tag(entries)
    group = {}

    entries.each do |e|
      if e.tags.empty?
        group[NO_TAG_TITLE] ||= []
        group[NO_TAG_TITLE] << e
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
