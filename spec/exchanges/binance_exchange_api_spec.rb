require 'rails_helper'

RSpec.describe BinanceExchangeApi do
  let(:binance) { BinanceExchangeApi.new }
  let(:order_response) do
    {
      'symbol'          => 'LTCBTC',
      'orderId'         => 1,
      'clientOrderId'   => 'myOrder1',
      'transactTime'    => 1499827319559
    }.to_json
  end

  let(:query_response) do
    {
      'symbol'          => 'LTCBTC',
      'orderId'         => 1,
      'clientOrderId'   => 'myOrder1',
      'price'           => '0.1',
      'origQty'         => '1.0',
      'executedQty'     => '1.0',
      'status'          => 'FILLED',
      'timeInForce'     => 'GTC',
      'type'            => 'LIMIT',
      'side'            => 'BUY',
      'stopPrice'       => '0.0',
      'icebergQty'      => '0.0',
      'time'            => 1499827319559
    }.to_json
  end

  before do
    WebMock.reset!
    stub_request(:post, 'https://api.binance.com/api/v3/order')
      .to_return(status: 200, body: order_response)
    stub_request(:get, /https:\/\/api\.binance\.com\/api\/v3\/order\?orderId=1&recvWindow=10000&signature=[a-z0-9]+&symbol=BTCUSD&timestamp=[0-9]+/)
      .to_return(status: 200, body: query_response)
  end

  describe '#place_order' do
    context 'WHEN a valid order is placed' do
      let(:order) { create(:order) }
      it 'SHOULD mark the order as pending' do
        binance.place_order(order)

        order.reload
        expect(order.status).to eq(:pending)
        expect(order.external_order_id).to eq('1')
      end
    end

    context 'WHEN an invalid order is placed' do
    end
  end

  describe '#track_order' do
    context 'WHEN the order is completed' do
      let(:order) { create(:order, status: :pending, external_order_id: 1) }
      it 'SHOULD be marked as :executed AND amount is updated' do
        binance.track_order(order)
        
        order.reload
        expect(order.status).to eq(:executed)
        expect(order.remaining_quantity).to eq(0)
      end
    end
  end
end