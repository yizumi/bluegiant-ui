require 'rails_helper'

RSpec.describe ProcessOrdersJob do
  let(:exchange) { create(:exchange, code: 'TEST') }
  let(:market) { create(:market, exchange: exchange) }
  let(:job) { ProcessOrdersJob.new }

  describe '#perform' do
    context 'GIVEN a open trade' do
      let!(:order) { create(:order, market: market) }

      it 'SHOULD process the order and have a status of :pending' do
        job.perform

        order.reload
        expect(order.status).to eq(:pending)
      end
    end
  end
end
