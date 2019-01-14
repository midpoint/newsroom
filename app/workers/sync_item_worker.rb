# frozen_string_literal: true

class SyncItemWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_and_while_executing

  attr_reader :item_id

  def perform(item_id)
    @item_id = item_id

    return if item.feed
    item.title = data.title
    item.save!
  end

  private

  def item
    @item ||= Item.find(item_id)
  end

  def data
    @data ||= ItemLoader.new(item.url)
  end
end
