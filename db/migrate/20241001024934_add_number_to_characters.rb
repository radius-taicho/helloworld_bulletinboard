class AddNumberToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :number, :integer
    add_index :characters, :number, unique: true  # 一意のインデックスを追加
  end
end
