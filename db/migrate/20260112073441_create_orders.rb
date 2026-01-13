class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status, default: "pending"
      t.integer :total_amount, null: false, default: 0
      t.string :payment_method, default: "cod"

      t.string :email
      t.string :phone
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :zip

      t.timestamps
    end
  end
end
