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
end
