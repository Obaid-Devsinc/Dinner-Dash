class AddItemsCountToCategories < ActiveRecord::Migration[8.1]
  def change
    add_column :categories, :items_count, :integer, default: 0, null: false
  end
end
