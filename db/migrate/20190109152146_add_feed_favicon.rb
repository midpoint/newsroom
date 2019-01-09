class AddFeedFavicon < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :favicon_reloaded_at, :datetime
    add_column :feeds, :favicon, :text
  end
end
