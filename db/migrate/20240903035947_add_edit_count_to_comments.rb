class AddEditCountToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :edit_count, :integer, default: 0, null: false
  end
end

