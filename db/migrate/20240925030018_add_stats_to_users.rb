class AddStatsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :offense_power, :integer, default: 0
    add_column :users, :defense_power, :integer, default: 0
    add_column :users, :speed, :integer, default: 0
    add_column :users, :luck, :integer, default: 0
    add_column :users, :status_points, :integer, default:0
  end
end
