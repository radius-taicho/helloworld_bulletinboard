class AddThoughtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :thought, :string
  end
end
