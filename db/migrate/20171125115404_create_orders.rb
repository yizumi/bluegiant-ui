# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :market_id, null: false
      t.string  :uuid, null: false
      t.string  :external_order_id
      t.integer :status, null: false
      t.integer :time_in_force, null: false
      t.integer :side, null: false
      t.integer :price_type, null: false
      t.decimal :price, null: false, precision: 15, scale: 10
      t.decimal :quantity, null: false, precision: 15, scale: 10
      t.decimal :remaining_quantity, null: false, precision: 15, scale: 10

      t.timestamps
    end

    add_index :orders, %i[market_id status]
    add_index :orders, [:uuid], unique: true
    add_index :orders, [:external_order_id]
  end
end
