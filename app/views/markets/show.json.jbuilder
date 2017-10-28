# frozen_string_literal: true

json.extract! @market, :id, :exchange_id, :code, :subscribed, :created_at, :updated_at
json.exchange do
  json.extract! @market.exchange, :id, :code, :name, :fee, :trade_enabled, :balance_enabled, :url
end
