# frozen_string_literal: true

class SearchController < ApplicationController
  ENTRIES_PER_PAGE = 20

  def index
    @feeds = current_user.feeds
    @stories = Search.new(query: params[:q], user: current_user).
               run.
               page((params[:page] || 1).to_i).per(ENTRIES_PER_PAGE)
  end
end
