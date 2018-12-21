# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username,     null: false
      t.string :email,        null: false, default: ""

      t.string :github_id,    null: false
      t.string :github_token, null: false


      t.timestamps null: false
    end

    add_index :users, :email,     unique: true
    add_index :users, :github_id, unique: true
  end
end
