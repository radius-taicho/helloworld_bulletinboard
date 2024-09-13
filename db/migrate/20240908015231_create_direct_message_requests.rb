class CreateDirectMessageRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :direct_message_requests do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.integer :status, default: 0, null: false  # enum 用の整数カラム

      t.timestamps
    end
  end
end
