# frozen_string_literal: true

class WelcomeController < ApplicationController
  ENTRIES_PER_PAGE = 20

  def index
    @feeds = current_user.feeds
    @stories = current_user.stories.
               order("items.published_at DESC").
               includes(item: :feed).
               page((params[:page] || 1).to_i).per(ENTRIES_PER_PAGE)
  end
end
