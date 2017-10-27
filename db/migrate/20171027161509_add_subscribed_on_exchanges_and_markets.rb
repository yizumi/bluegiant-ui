class AddSubscribedOnExchangesAndMarkets < ActiveRecord::Migration[5.1]
  def change
    add_column :exchanges, :subscribed, :boolean, default: 0, null: false, after: :url
    add_column :markets, :subscribed, :boolean, default: 0, null: false, after: :code
    add_index :exchanges, :subscribed
    add_index :markets, :subscribed
  end
end
