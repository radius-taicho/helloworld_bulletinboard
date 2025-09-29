class CreateCharacterAbilities < ActiveRecord::Migration[7.1]
  def change
    create_table :character_abilities do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.references :character, null: false, foreign_key: true

      t.timestamps
    end
  end
end

