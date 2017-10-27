# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  market_id  :integer          not null
#  side       :integer          not null
#  price      :decimal(19, 10)  not null
#  quantity   :decimal(19, 10)  not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Order < ApplicationRecord
  extend Enumerize
  belongs_to :market

  enum side: { ask: 0, bid: 1 }

  def self.from_json(market, side, json)
    o = Order.new
    o.market = market
    o.side = side
    o.price = BigDecimal.new(json[:price])
    o.quantity = BigDecimal.new(json[:quantity])
    o
  end
end
