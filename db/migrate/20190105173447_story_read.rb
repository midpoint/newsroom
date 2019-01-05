class StoryRead < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :read, :boolean, default: false
  end
end
