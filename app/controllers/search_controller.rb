# frozen_string_literal: true

class SearchController < ApplicationController
  ENTRIES_PER_PAGE = 20

  def index
    if params[:q].blank?
      return redirect_to(q: 'read:false')
    end

    @tags = Tag.find_all(current_user)
    @stories = Search.new(query: params[:q], user: current_user).
               run.
               page((params[:page] || 1).to_i).per(ENTRIES_PER_PAGE)
    respond_with @stories
  end
end
