require 'rails_helper'
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

RSpec.describe ChessController, type: :controller do
  describe 'chess#index action' do
    it 'successfully displays page' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'should list games with less than 2 players as available' do
      DatabaseCleaner.clean
      FactoryGirl.create(:game)
      FactoryGirl.create(:game)
      FactoryGirl.create(:game)
      get :index
      expect(response).to have_http_status(:success)
      games = Game.available
      expect(games.count).to eq(3)
    end

    it 'should not list games with 2 players as available' do
      DatabaseCleaner.clean
      user_id1 = FactoryGirl.create(:user).id
      user_id2 = FactoryGirl.create(:user).id
      FactoryGirl.create(:game, white_player: user_id1, black_player: user_id2)
      FactoryGirl.create(:game)
      FactoryGirl.create(:game)
      get :index
      expect(response).to have_http_status(:success)
      games = Game.available
      expect(games.count).to eq(2)
    end
  end
end
