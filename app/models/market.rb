# frozen_string_literal: true

# == Schema Information
#
# Table name: markets
#
#  id          :integer          not null, primary key
#  exchange_id :integer          not null
#  code        :string(255)      not null
#  subscribed  :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_markets_on_exchange_id_and_code  (exchange_id,code)
#  index_markets_on_subscribed            (subscribed)
#

class Market < ApplicationRecord
  belongs_to :exchange

  def self.from_json(exchange, json)
    m = Market.new
    m.exchange = exchange
    m.code = json[:mkt_name]
    m
  end

  def as_json(arg)
    json = super
    json[:subscription_code] = "ORDER-#{exchange.code}--#{code.gsub('/', '--')}"
    json
  end
end
