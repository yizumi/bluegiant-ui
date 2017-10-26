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

class Market < ApplicationRecord
  belongs_to :exchange

  def self.from_json(exchange, json)
    m = Market.new
    m.exchange = exchange
    m.code = json[:mkt_name]
    m
  end
end