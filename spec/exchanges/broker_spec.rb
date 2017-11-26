# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Broker do
  let(:order_response) do
    {
      'symbol'          => 'LTCBTC',
      'orderId'         => 1,
      'clientOrderId'   => 'myOrder1',
      'transactTime'    => 1_499_827_319_559
    }.to_json
  end

  before do
    WebMock.reset!
    stub_request(:post, 'https://api.binance.com/api/v3/order')
      .to_return(status: 200, body: order_response)
  end

  let(:exchange) { create(:exchange, code: 'BINA') }
  let(:market) { create(:market, exchange: exchange, code: 'LTCBTC') }

  describe '#process' do
    context 'GIVEN a valid order' do
      let(:order) { create(:order, market: market) }
      it 'SHOULD find the right exchange and forward it' do
        Broker.process(order)

        order.reload
        expect(order.external_order_id).to eq('1')
      end
    end
  end
end
