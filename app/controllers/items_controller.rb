# frozen_string_literal: true

class ItemsController < ApplicationController
  protect_from_forgery except: :create

  def new
    @item = Item.new
  end

  def create
    @item = Item.where(url: item_params[:url]).first_or_create do |i|
      i.published_at = Time.now
    end

    if @item.persisted?
      SyncItemWorker.perform_async(@item.id)
      current_user.stories.where(item_id: @item.id).first_or_create! do |s|
        s.tags = Tag::AUTOMATED_MANUAL
      end
    end

    respond_with @item, location: -> { root_path }
  end

  private

  def item_params
    params.require(:item).permit(:url)
  end
end
