class CreateStatusEffects < ActiveRecord::Migration[7.1]
  def change
    create_table :status_effects do |t|
      t.string :name, null: false
      t.integer :duration, null: false
      t.references :character, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
