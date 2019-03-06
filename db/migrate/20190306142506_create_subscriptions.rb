# frozen_string_literal: true

class FeedsUser < ActiveRecord::Base; end

class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def up
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :feed_id

      t.timestamps

      t.index [:user_id, :feed_id], unique: true
    end

    FeedsUser.all.each do |f|
      Subscription.create!(user_id: f.user_id, feed_id: f.feed_id)
    end

    drop_table :feeds_users
  end

  def down
    create_join_table :users, :feeds do |t|
      t.index [:user_id, :feed_id]
    end

    Subscription.all.each do |s|
      FeedsUser.create!(user_id: s.user_id, feed_id: s.feed_id)
    end

    drop_table :subscriptions
  end
end
