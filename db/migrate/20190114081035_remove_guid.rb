# frozen_string_literal: true

class RemoveGuid < ActiveRecord::Migration[5.2]
  def change
    remove_column :items, :guid
    add_index :items, [:url, :feed_id], unique: true
  end
end
