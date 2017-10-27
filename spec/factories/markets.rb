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

FactoryBot.define do
  factory :market do
    code 'BTC/USD'
    association :exchange, factory: :exchange
  end
end
