# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CoinigyService do
  before do
    stub_request(:post, 'https://api.coinigy.com/api/v1/exchanges')
      .to_return(status: 200, body: exchanges_message)
    stub_request(:post, 'https://api.coinigy.com/api/v1/markets')
      .with(body: '{"exchange_code":"BTCE"}').to_return(status: 200, body: markets_message)
    stub_request(:post, 'https://api.coinigy.com/api/v1/data')
      .with(body: '{"exchange_code":"BTCE","exchange_market":"BTC/USD","type":"orders"}')
      .to_return(status: 200, body: orders_message)
  end
  def exchanges_message
    '{"data":[{' \
    '"exch_id": "2",' \
    '"exch_name": "BTC-e",' \
    '"exch_code": "BTCE",' \
    '"exch_fee": "0.003",' \
    '"exch_trade_enabled": "1",' \
    '"exch_balance_enabled": "1",' \
    '"exch_url": "https://btc-e.com/"' \
    '}]}'
  end

  def markets_message
    '{"data":[{' \
    '"exch_id": "62",' \
    '"exch_name": "Global Digital Asset Exchange",' \
    '"exch_code": "BTCE",' \
    '"mkt_id": "139",' \
    '"mkt_name": "BTC/CAD",' \
    '"exchmkt_id": "7432"' \
    '}]}'
  end

  def orders_message
    '{"data":[{' \
    '"exch_code": "GDAX",' \
    '"primary_curr_code": "BTC",' \
    '"secondary_curr_code": "USD",' \
    '"type": "orders",' \
    '"asks": [{' \
    '"price": "696.8600000000",' \
    '"quantity": "0.0171218000",' \
    '"total": "11.9314975480"' \
    '}]' \
    '}]}'
  end
  describe '#refresh_exchanges' do
    before { described_class.new.refresh_exchanges }
    let(:exchange) { Exchange.first }
    it 'should return exchange information' do
      expect(exchange.name).to eq('BTC-e')
      expect(exchange.code).to eq('BTCE')
      expect(exchange.trade_enabled).to be_truthy
      expect(exchange.balance_enabled).to be_truthy
      expect(exchange.url).to eq('https://btc-e.com/')
    end
  end
  describe '#refresh_markets' do
    let(:exchange) { create(:exchange) }
    let(:market) { described_class.new.refresh_markets(exchange).first }
    it 'should return markets within the given exchange' do
      expect(market.exchange.code).to eq('BTCE')
      expect(market.code).to eq('BTC/CAD')
    end
  end
  describe '#refresh_orders' do
    let(:market) { create(:market) }
    let(:order) { described_class.new.refresh_orders(market).first }
    it 'should return orders for the givne exchange' do
      expect(order.side).to eq(:ask)
      expect(order.price).to eq(696.86)
      expect(order.quantity).to eq(0.0171218000)
    end
  end
end
