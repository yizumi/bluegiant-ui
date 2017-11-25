# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id                 :integer          not null, primary key
#  market_id          :integer          not null
#  uuid               :string(255)      not null
#  external_order_id  :string(255)
#  status             :integer          not null
#  side               :integer          not null
#  price_type         :integer          not null
#  price              :decimal(15, 10)  not null
#  quantity           :decimal(15, 10)  not null
#  remaining_quantity :decimal(15, 10)  not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_orders_on_external_order_id     (external_order_id)
#  index_orders_on_market_id_and_status  (market_id,status)
#  index_orders_on_uuid                  (uuid) UNIQUE
#

class Order < ApplicationRecord
  belongs_to :market

  enum side: { buy: 1, sell: 2 }
  enum price_type: { limit_order: 3, stop_limit_order: 6, limit_margin_order: 8, stop_limit_margin_order: 9 }
  enum status: { requested: 1, submitted: 2, executed: 3 }
end
