# == Schema Information
#
# Table name: exchanges
#
#  id              :integer          not null, primary key
#  code            :string(255)      not null
#  name            :string(255)      not null
#  fee             :decimal(15, 10)
#  trade_enabled   :boolean          not null
#  balance_enabled :boolean          not null
#  url             :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Exchange < ApplicationRecord
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
