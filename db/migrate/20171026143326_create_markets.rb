class CreateMarkets < ActiveRecord::Migration[5.1]
  def change
    create_table :markets do |t|
      t.integer :exchange_id, null: false
      t.string :code, null: false

      t.timestamps
    end
    add_index :markets, [:exchange_id, :code]
  end
end
