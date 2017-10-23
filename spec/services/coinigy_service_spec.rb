require 'rails_helper'

RSpec.describe CoinigyService do
  before do
    stub_request(:post, 'https://api.coinigy.com/api/v1/exchanges').
      to_return(status: 200, body: '''
        {
          "data":[
            {
              "exch_id": "2",
              "exch_name": "BTC-e",
              "exch_code": "BTCE",
              "exch_fee": "0.003",
              "exch_trade_enabled": "1",
              "exch_balance_enabled": "1",
              "exch_url": "https://btc-e.com/"
            }
          ]
        }''')
  end
  describe '#exchanges' do
    let(:exchange) { described_class.new.exchanges.first }
    it 'should return exchange information' do
      expect(exchange.name).to eq('BTC-e')
      expect(exchange.code).to eq('BTCE')
      # expect(exchange.fee).to eq(0.003)
      expect(exchange.trade_enabled).to be_truthy
      expect(exchange.balance_enabled).to be_truthy
      expect(exchange.url).to eq('https://btc-e.com/')
    end
  end
end
