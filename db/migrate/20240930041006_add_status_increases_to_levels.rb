class AddStatusIncreasesToLevels < ActiveRecord::Migration[7.1]
  def change
    add_column :levels, :offense_increase, :integer, default: 0
    add_column :levels, :defense_increase, :integer, default: 0
    add_column :levels, :speed_increase, :integer, default: 0
    add_column :levels, :luck_increase, :integer, default: 0
  end
end
