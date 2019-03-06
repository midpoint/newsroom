# frozen_string_literal: true

class CreateFeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :url, null: false

      t.timestamps
    end
    add_index :feeds, :url, unique: true

    create_join_table :users, :feeds do |t|
      t.index [:user_id, :feed_id]
    end
  end
end
