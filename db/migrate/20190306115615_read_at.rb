# frozen_string_literal: true

class ReadAt < ActiveRecord::Migration[5.2]
  def up
    add_column :stories, :read_at, :datetime, default: nil
    Story.where(read: true).update_all(read_at: Time.now)
    remove_column :stories, :read
  end

  def down
    add_column :stories, :read, :bool, default: false
    Story.where("read_at IS NOT NULL").update_all(read: true)
    remove_column :stories, :read_at
  end
end
