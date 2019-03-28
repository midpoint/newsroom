# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :tags, :text, array: true, default: []
    add_column :stories, :tags, :text, array: true, default: []
  end
end
