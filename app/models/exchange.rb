# frozen_string_literal: true
# == Schema Information
#
# Table name: exchanges
#
#  id              :integer          not null, primary key
#  code            :string(255)      not null
#  name            :string(255)
#  fee             :decimal(15, 10)
#  trade_enabled   :boolean
#  balance_enabled :boolean
#  url             :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_exchanges_on_code  (code)
#

class Exchange < ApplicationRecord
  has_many :markets

  def self.from_json(json)
    Exchange.new(
      code: json[:exch_code],
      name: json[:exch_name],
      fee: BigDecimal.new(json[:exch_fee]),
      trade_enabled: json[:exch_trade_enabled]&.to_i == 1,
      balance_enabled: json[:exch_balance_enabled]&.to_i == 1,
      url: json[:exch_url]
    )
  end
end
