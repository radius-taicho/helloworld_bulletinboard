class CreateExps < ActiveRecord::Migration[7.1]
  def change
    create_table :exps do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :points, null: false
      t.string :source, null: false # 経験値の由来（例: コメント、スレッド作成など）

      t.timestamps
    end
  end
end
