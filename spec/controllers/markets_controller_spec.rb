# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MarketsController, type: :controller do
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
  describe '#create' do
    before do
      stub_request(:post, 'https://api.coinigy.com/api/v1/markets')
        .with(body: '{"exchange_code":"BTCE"}').to_return(status: 200, body: markets_message)
    end
    context 'AS Alex WHEN refreshes the market list for an exchange' do
      let(:exchange) { create(:exchange) }
      it 'THEN should update the market list' do
        post :create, params: { exchange_id: exchange.code }

        expect(response).to have_http_status(302)

        market = Market.first
        expect(market.code).to eq('BTC/CAD')
      end
    end
  end
  describe '#show' do
    let(:market) { create(:market) }
    context 'AS Alex WHEN accesses market description' do
      render_views
      it 'THEN should show the description of the market' do
        get :show, params: { id: market.id, format: :json }

        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['code']).to eq(market.code)
      end
    end
  end
end
