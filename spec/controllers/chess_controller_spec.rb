require 'rails_helper'

RSpec.describe ChessController, type: :controller do
  describe 'chess#index action' do
    it 'successfully displays page' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'should list games with less than 2 players as available' do
    	game = FactoryGirl.create(:game)
      get :index
      expect(response).to have_http_status(:success)
      games = Game.available
      expect(games.count).to eq(1)
    end

    it 'should not list games with 2 players as available' do
    	game = FactoryGirl.create(:fullgame)
      get :index
      expect(response).to have_http_status(:success)
      games = Game.available
      expect(games.count).to eq(0)
    end  
  end
end
