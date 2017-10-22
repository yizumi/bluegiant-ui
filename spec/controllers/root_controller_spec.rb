require 'rails_helper'

RSpec.describe RootController, type: :controller do
  describe '#index' do
    context 'AS Alex' do
      context 'WHEN accesses the application root' do
        render_views
        it 'THEN shows the header' do
          get :index

          expect(response).to have_http_status(:success)
          expect(response.body).to have_tag 'h1', 'Blue Giant'
        end
      end
    end
  end
end
