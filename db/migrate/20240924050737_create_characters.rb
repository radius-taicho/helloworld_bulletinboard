class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.string :name, null: false
      t.string :image, null: false
      t.integer :offense_power
      t.integer :defense_power
      t.integer :speed
      t.integer :likeability, default: 0
      t.integer :experience_points
      t.string :status_effect
      t.text :traits
      t.string :favorite_item
      t.text :backstory
      t.integer :max_hp
      t.integer :current_hp
      t.integer :healing_power
      t.string :alignment

      t.timestamps
    end
  end
end
