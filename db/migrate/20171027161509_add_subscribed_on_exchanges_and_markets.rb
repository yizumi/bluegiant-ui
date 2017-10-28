class AddSubscribedOnExchangesAndMarkets < ActiveRecord::Migration[5.1]
  def change
    add_column :markets, :subscribed, :boolean, default: 0, null: false, after: :code
    add_index :markets, :subscribed
  end
end
