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

FactoryBot.define do
  factory :order do
    
  end
end
