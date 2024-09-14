class CreateLevels < ActiveRecord::Migration[7.1]
  def change
    create_table :levels do |t|
      t.integer :level_number, null: false
      t.integer :exp_required, null: false
      t.integer :hp_increase, null: false
      t.string  :reward_type                 # レベルアップ時に得られる報酬の種類（スキル、アイテム、通貨など）
      t.string  :reward_value                # 報酬の詳細（アイテム名、通貨の量など）

      t.timestamps
    end

    add_index :levels, :level_number, unique: true
  end
end
