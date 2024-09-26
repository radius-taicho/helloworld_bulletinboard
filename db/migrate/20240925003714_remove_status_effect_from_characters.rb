class RemoveStatusEffectFromCharacters < ActiveRecord::Migration[7.1]
  def change
    remove_column :characters, :status_effect, :string
  end
end
