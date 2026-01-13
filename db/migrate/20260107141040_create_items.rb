class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.text :description
      t.decimal :price, null: false, default: 0
      t.boolean :retired, default: false
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :items, :title, unique: true
  end
end
