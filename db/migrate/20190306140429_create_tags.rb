# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :value

      t.timestamps

      t.index :value, unique: true
    end

    create_join_table :subscriptions, :tags do |t|
      t.index [:subscription_id, :tag_id]
    end

    create_join_table :stories, :tags do |t|
      t.index [:story_id, :tag_id]
    end
  end
end
