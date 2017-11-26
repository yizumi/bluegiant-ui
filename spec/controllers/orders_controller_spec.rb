require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:exchange) { create(:exchange, code: 'TEST') }
  describe '#index' do
  end

  describe '#show' do
  end

  describe '#create' do
    context 'GIVEN a market' do
      let(:market) { create(:market, exchange: exchange) }
      context 'WHEN Alex submits a new order' do
        let(:create_params) do
          {
            exchange_id: exchange.code,
            market_id: market.code,
            time_in_force: 'good_till_cancel',
            side: 'buy',
            price_type: 'limit_order',
            price: 1.0,
            quantity: 0.1
          }
        end
        it 'THEN orders should be created' do
          post :create, params: create_params

          expect(response).to have_http_status(:created)
          json = JSON.parse(response.body)

          order = Order.find(json['id'])
          expect(order.market_id).to eq market.id
          expect(order.time_in_force).to eq :good_till_cancel
          expect(order.side).to eq :buy
          expect(order.price_type).to eq :limit_order
          expect(order.price).to eq 1.0
          expect(order.quantity).to eq 0.1
        end
      end
    end
  end

  describe '#delete' do
  end
end
