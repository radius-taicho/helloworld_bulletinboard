class AddRelatedEntityToExps < ActiveRecord::Migration[7.1]
  def change
    add_reference :exps, :related_entity, polymorphic: true, null: false
  end
end
