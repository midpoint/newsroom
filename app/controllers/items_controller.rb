# frozen_string_literal: true

class ItemsController < ApplicationController

  def new
    @item = Item.new
  end

  def create
    @item = Item.where(url: item_params[:url]).first_or_create

    if @item.persisted?
      SyncItemWorker.perform_async(@item.id)
      current_user.stories.where(item_id: @item.id).first_or_create!

      redirect_to root_path
    else
      render :new
    end
  end

  private

  def item_params
    params.require(:item).permit(:url)
  end
end
