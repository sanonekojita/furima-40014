class ChangeItemsTable < ActiveRecord::Migration[7.0]
  def change
    add_reference :items, :category, null: false, foreign_key: true
    add_reference :items, :child_category, null: false, foreign_key: { to_table: :categories }
    add_reference :items, :grandchild_category, null: false, foreign_key: { to_table: :categories }
  end
end
