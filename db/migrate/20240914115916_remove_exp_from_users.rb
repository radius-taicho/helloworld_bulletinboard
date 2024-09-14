class RemoveExpFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :experience, :integer
  end
end
