class AddUserAdmin < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.boolean :admin
    end
  end
end
