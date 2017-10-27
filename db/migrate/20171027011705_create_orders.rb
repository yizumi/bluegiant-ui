# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :market_id, null: false
      t.integer :side, null: false
      t.decimal :price, precision: 19, scale: 10, null: false
      t.decimal :quantity, precision: 19, scale: 10, null: false

      t.timestamps
    end
  end
end
