# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExchangesController, type: :controller do
  describe '#index' do
    context 'AS Alex GIVEN exchange WHEN accesses index' do
      render_views
      before { create(:exchange) }
      it 'should show result' do
        get :index
        expect(response.body).to have_tag('td.bg-exchange-name', 'BTC-e')
        expect(response.body).to have_tag('td.bg-exchange-code', 'BTCE')
      end
    end
  end
  describe '#show' do
    context 'AS Alex GIVEN market WHEN accesses BTCE' do
      render_views
      let!(:exchange) { create(:exchange) }
      let!(:market) { create(:market, exchange: exchange) }
      it 'THEN should be able to see a market' do
        get :show, params: { id: exchange.code }
        expect(response.body).to have_tag('td.bg-market-code', market.code)
      end
    end
  end
end
