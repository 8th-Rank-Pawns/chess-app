require 'rails_helper'

RSpec.describe ChessController, type: :controller do
  describe 'chess#index action' do
    it 'successfully displays page' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
