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

FactoryBot.define do
  factory :exchange do
    code 'BTCE'
    name 'BTC-e'
    fee 0.003
    trade_enabled true
    balance_enabled true
    url 'https://btc-e.com/'
  end
end
