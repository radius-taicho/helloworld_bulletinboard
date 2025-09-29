class AddStatusPointIncreaseToLevels < ActiveRecord::Migration[7.1]
  def change
    add_column :levels, :status_point_increase, :integer, default: 0
  end
end
