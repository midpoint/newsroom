class AddFeedError < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :error, :string
  end
end
