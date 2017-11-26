class AddErrorMessageToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :error_message, :string, after: :remaining_quantity
  end
end
