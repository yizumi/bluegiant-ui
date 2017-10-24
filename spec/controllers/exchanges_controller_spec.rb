# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExchangesController, type: :controller do
  before do
    stub_request(:post, 'https://api.coinigy.com/api/v1/exchanges')
      .to_return(status: 200, body: '''
        {"data":[{"exch_id": "2","exch_name": "BTC-e","exch_code": "BTCE","exch_fee": "0.003","exch_trade_enabled": "1","exch_balance_enabled": "1","exch_url": "https://btc-e.com/"}]}
      ''')
  end
  describe '#index' do
    context 'AS Alex WHEN accesses index' do
      render_views
      it 'should show result' do
        get :index
        expect(response.body).to have_tag('td.bg-exchange-name', 'BTC-e')
        expect(response.body).to have_tag('td.bg-exchange-code', 'BTCE')
      end
    end
  end
end
