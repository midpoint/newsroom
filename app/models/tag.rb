# frozen_string_literal: true

class Tag
  AUTOMATED_MANUAL = 'manual'

  def self.find_all(user)
    (
      user.subscriptions.select(:tags).map(&:tags) +
      user.stories.select(:tags).map(&:tags)
    ).flatten.uniq
  end
end
