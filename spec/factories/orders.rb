# frozen_string_literal: true
# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  market_id  :integer          not null
#  side       :string(255)      not null
#  price      :decimal(19, 10)  not null
#  quantity   :decimal(19, 10)  not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


FactoryBot.define do
  factory :order do
  end
end
