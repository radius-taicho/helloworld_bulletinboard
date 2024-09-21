class AddHpToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :hp, :integer, default: 3
    add_column :users, :max_hp, :integer, default: 3
  end
end
