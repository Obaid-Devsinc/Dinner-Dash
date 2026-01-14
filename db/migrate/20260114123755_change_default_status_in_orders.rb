class ChangeDefaultStatusInOrders < ActiveRecord::Migration[8.1]
  def change
    change_column_default :orders, :status, from: "pending", to: "ordered"
  end
end
