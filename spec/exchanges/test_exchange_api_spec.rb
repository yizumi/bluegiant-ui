# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestExchangeApi do
  let(:api) { TestExchangeApi.new(1) }
  let(:exchange) { create(:exchange, code: 'TEST') }
  let(:market) { create(:market, exchange: exchange) }

  describe '#place_order' do
    context 'GIVEN valid order' do
      let(:order) { create(:order, market: market) }

      it 'SHOULD be processed and have status of pending' do
        api.place_order(order)

        order.reload
        expect(order.status).to eq(:pending)
      end
    end
  end

  describe '#track_order' do
    context 'GIVEN pending order' do
      let(:order) { create(:order, market: market, status: :pending) }

      it 'SHOULD be processed and have status of executed' do
        api.track_order(order)

        order.reload
        expect(order.status).to eq(:executed)
      end
    end
    context 'GIVEN pending_cancel order' do
      let(:order) { create(:order, market: market, status: :pending_cancel) }

      it 'SHOULD be processed and have status of executed' do
        api.track_order(order)

        order.reload
        expect(order.status).to eq(:cancelled)
      end
    end
  end

  describe '#cancel_order' do
    context 'GIVEN valid order' do
      let(:order) { create(:order, market: market, status: :requested_cancel) }

      it 'SHOULD be processed and have status of pending_cancel' do
        api.cancel_order(order)

        order.reload
        expect(order.status).to eq(:pending_cancel)
      end
    end
  end
end
