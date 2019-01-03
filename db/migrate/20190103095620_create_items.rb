class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.integer :feed_id

      t.string :guid, null: false

      t.string :title
      t.string :url, null: false
      t.datetime :published_at

      t.timestamps
    end

    add_index :items, [:guid, :feed_id], unique: true
  end
end
