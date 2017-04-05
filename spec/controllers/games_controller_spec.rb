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
      user = FactoryGirl.create(:user)
      sign_in user
      post :create, game: { name: 'Player 1' }
      game = Game.last
      expect(response).to redirect_to game_path(game.id)
      expect(game.name).to eq('Player 1')
    end

    it 'should populate board with pieces in correct starting positions after game creation' do
      user = FactoryGirl.create(:user)
      sign_in user
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

    it 'should update a promoted pawn' do
      game = FactoryGirl.create(:game)
      FactoryGirl.create(:pawn, horizontal_position: 4, vertical_position: 1, color: 'white', game: game)
      get :show, id: game.id, p_type: 'Queen'
      promoted = game.pieces.where(horizontal_position: 4, vertical_position: 1).first.type
      expect(promoted).to eq('Queen')
    end

    context 'checkmate happens when king is in check and cannot move or be protected' do
      game = FactoryGirl.create(:game)
      game.populate_board!
      black_pawn7 = game.pieces.find_by(horizontal_position: 7, vertical_position: 7)
      black_pawn6 = game.pieces.find_by(horizontal_position: 6, vertical_position: 7)
      black_pawn4 = game.pieces.find_by(horizontal_position: 4, vertical_position: 7)
      white_pawn5 = game.pieces.find_by(horizontal_position: 5, vertical_position: 2)
      white_queen = game.pieces.find_by(type: 'Queen', color: 'white')
      black_knight1 = game.pieces.find_by(horizontal_position: 2, vertical_position: 8)
      black_knight2 = game.pieces.find_by(horizontal_position: 7, vertical_position: 8)
      black_pawn8 = game.pieces.find_by(horizontal_position: 8, vertical_position: 7)
      black_rook2 = game.pieces.find_by(horizontal_position: 8, vertical_position: 8)
      black_pawn5 = game.pieces.find_by(horizontal_position: 5, vertical_position: 7)
      white_pawn5.move_to!(horizontal_position: 5, vertical_position: 4)
      black_pawn7.move_to!(horizontal_position: 7, vertical_position: 5)
      black_pawn6.move_to!(horizontal_position: 6, vertical_position: 5)
      white_queen.move_to!(horizontal_position: 8, vertical_position: 5)

      it 'performs fast checkmate aka fool\'s checkmate' do
        expect(game.checkmate!('black')).to eq(true)
        # Would have like to test the flash messages, but the tests I wrote didn't pass.
        # However, flash message seems to pop up properly and checkmate logic seems to be working correctly.
      end

      it '(1)not checkmate if opening (2)checkmate again if opening becomes occupied' do
        white_queen.move_to!(horizontal_position: 8, vertical_position: 4)
        black_pawn4.move_to!(horizontal_position: 4, vertical_position: 5)
        white_queen.move_to!(horizontal_position: 8, vertical_position: 5)
        expect(game.checkmate!('black')).to eq(false)
        white_queen.move_to!(horizontal_position: 8, vertical_position: 4)
        black_knight1.move_to!(horizontal_position: 4, vertical_position: 7)
        white_queen.move_to!(horizontal_position: 8, vertical_position: 5)
        expect(game.checkmate!('black')).to eq(true)
      end

      it 'not checkmate if attacking piece can be captured' do
        white_queen.move_to!(horizontal_position: 8, vertical_position: 4)
        black_knight2.move_to!(horizontal_position: 6, vertical_position: 6)
        white_queen.move_to!(horizontal_position: 8, vertical_position: 5)
        expect(game.checkmate!('black')).to eq(false)
      end

      it 'not checkmate if path from attacking piece to king can be blocked' do
        white_queen.move_to!(horizontal_position: 8, vertical_position: 4)
        black_pawn8.move_to!(horizontal_position: 8, vertical_position: 6)
        black_rook2.move_to!(horizontal_position: 8, vertical_position: 7)
        white_queen.move_to!(horizontal_position: 8, vertical_position: 5)
        expect(game.checkmate!('black')).to eq(false)
      end

      it 'checkmate if king is blocked in and attacking knight can\'t be captured' do
        white_queen.move_to!(horizontal_position: 8, vertical_position: 4)
        black_pawn5.move_to!(horizontal_position: 5, vertical_position: 5)
        black_knight2.move_to!(horizontal_position: 8, vertical_position: 6)
        FactoryGirl.create(:pawn, horizontal_position: 6, vertical_position: 7, color: 'black', game: game)
        FactoryGirl.create(:knight, horizontal_position: 5, vertical_position: 7, color: 'black', game: game)
        FactoryGirl.create(:knight, horizontal_position: 6, vertical_position: 6, color: 'white', game: game)
        expect(game.checkmate!('black')).to eq(true)
      end
    end

    context'stalemate method working correctly' do
      it 'returns true when game is in stalemate' do
        game = FactoryGirl.create(:game)
        FactoryGirl.create(:king, horizontal_position: 7, vertical_position: 3, color: 'white', game: game)
        FactoryGirl.create(:rook, horizontal_position: 1, vertical_position: 1, color: 'white', game: game)
        FactoryGirl.create(:bishop, horizontal_position: 7, vertical_position: 1, color: 'black', game: game)
        FactoryGirl.create(:king, horizontal_position: 8, vertical_position: 1, color: 'black', game: game)
        expect(game.stalemate?('black')).to eq true
      end
    end
  end

  describe 'games#update action' do
    it 'should successfully update the game black_player to the currently logged-in user id' do
      user = FactoryGirl.create(:user)
      sign_in user
      game = FactoryGirl.create(:game)
      put :update, id: game.id, game: { black_player: user.id }
      game.reload
      expect(game.black_player).to eq user.id
    end
  end
end
