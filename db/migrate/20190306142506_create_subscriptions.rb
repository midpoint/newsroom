class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def up
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :feed_id

      t.timestamps

      t.index [:user_id, :feed_id], unique: true
    end

    User.all.each do |user|
      user.feeds.each do |feed|
        Subscription.create!(user: user, feed: feed)
      end
    end

    drop_table :feeds_users
  end

  def down
    create_join_table :users, :feeds do |t|
      t.index [:user_id, :feed_id]
    end

    Subscription.all.each do |s|
      s.user.feeds << s.feed
    end
  end
end
