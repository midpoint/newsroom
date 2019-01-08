# frozen_string_literal: true

class CreateStories < ActiveRecord::Migration[5.2]
  def change
    create_table :stories do |t|
      t.integer :user_id
      t.integer :item_id

      t.timestamps
    end

    add_index :stories, [:user_id, :item_id], unique: true
  end
end
