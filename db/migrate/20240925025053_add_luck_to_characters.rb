class AddLuckToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :luck, :integer
  end
end
