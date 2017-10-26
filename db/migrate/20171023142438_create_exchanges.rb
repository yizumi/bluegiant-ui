# frozen_string_literal: true

class CreateExchanges < ActiveRecord::Migration[5.1]
  def change
    create_table :exchanges do |t|
      t.string :code, null: false
      t.string :name
      t.decimal :fee, precision: 15, scale: 10
      t.boolean :trade_enabled
      t.boolean :balance_enabled
      t.string :url

      t.timestamps
    end
    add_index :exchanges, [:code]
  end
end
