class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :name          # グループチャットや特定のルームの名前
      t.boolean :is_group, default: false  # グループチャットかどうかを示すフラグ
      t.timestamps
    end
  end
end
