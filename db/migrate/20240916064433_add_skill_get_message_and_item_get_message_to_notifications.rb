class AddSkillGetMessageAndItemGetMessageToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :skill_get_message, :string
    add_column :notifications, :item_get_message, :string
  end
end
