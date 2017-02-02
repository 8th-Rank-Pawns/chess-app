require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'games#new action' do
    it 'should successfully show the new form' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'games#create action' do
    it 'should successfully create a game in our database' do
      post :create, game: { name: 'Player 1' }
      expect(response).to redirect_to root_path

      game = Game.last
      expect(game.name).to eq('Player 1')
    end
  end

  describe 'games#show action' do
    it 'should successfully show the page if a game is found' do
      game = FactoryGirl.create(:game)
      get :show, id: game.id
      expect(response).to have_http_status(:success)
    end

    it 'should return a 404 error if the game is not found' do
      get :show, id: 'Checkers'
      expect(response).to have_http_status(:not_found)
    end
  end
end
