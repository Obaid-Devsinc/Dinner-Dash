class AddOrdersCountToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :orders_count, :integer, default: 0, null: false
  end
end
