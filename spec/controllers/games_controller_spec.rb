require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'games#new action' do
    it 'should successfully show the new form' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'games#create action' do
    it 'should successfully create a game in our database & redirect to new game' do
      post :create, game: { name: 'Player 1' }
      game = Game.last
      expect(response).to redirect_to game_path(game.id)
      expect(game.name).to eq('Player 1')
    end

    it 'should populate board with pieces in correct starting positions after game creation' do
      post :create, game: { name: 'Player 1' }
      game = Game.last
      piece_king = game.pieces.where(horizontal_position: 5, vertical_position: 1).first.type
      piece_bishop = game.pieces.where(horizontal_position: 6, vertical_position: 1, color: 'white').first.type
      piece_pawn = game.pieces.where(horizontal_position: 3, vertical_position: 2).first.type
      piece_pawn_black = game.pieces.where(horizontal_position: 8, vertical_position: 7, color: 'black').first.type
      piece_queen_black = game.pieces.where(horizontal_position: 4, vertical_position: 8).first.type
      expect(piece_king).to eq('King')
      expect(piece_bishop).to eq('Bishop')
      expect(piece_pawn).to eq('Pawn')
      expect(piece_pawn_black).to eq('Pawn')
      expect(piece_queen_black).to eq('Queen')
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

  describe 'games#update action' do
    it 'should successfully update the game black_player_id to the currently logged-in user id' do
      game = FactoryGirl.create(:game)
      patch :update, id: user, game: { black_player_id: current.user}
      expect(response).to redirect_to root_path
      game.reload
      expect(black_player).to eq current_user
    end

    it 'should have http 404 error if the game could not be found' do

    end
  end
end













