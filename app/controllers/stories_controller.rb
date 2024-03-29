# frozen_string_literal: true

class StoriesController < ApplicationController
  def read
    story = current_user.stories.find(params[:id])
    story.update_column(:read_at, Time.now)
    head :ok
  end
end
