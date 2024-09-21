class AddFieldsToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :next_experience_point, :integer
    add_column :notifications, :required_comment_count, :integer
  end
end
