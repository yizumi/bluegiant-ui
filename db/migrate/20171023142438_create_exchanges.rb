# frozen_string_literal: true

class CreateExchanges < ActiveRecord::Migration[5.1]
  def change
    create_table :exchanges do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.decimal :fee, precision: 15, scale: 10
      t.boolean :trade_enabled, null: false
      t.boolean :balance_enabled, null: false
      t.string :url

      t.timestamps
    end
    add_index :exchanges, [:code]
  end
end
