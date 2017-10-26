# frozen_string_literal: true

# == Schema Information
#
# Table name: markets
#
#  id          :integer          not null, primary key
#  exchange_id :integer          not null
#  code        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :market do
    code 'BTC/CAD'
    association :exchange, factory: :exchange
  end
end
