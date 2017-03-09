require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  describe 'pieces#update action' do
    game = FactoryGirl.create(:game)
    game.populate_board!
    pawn = game.pieces.find_by(horizontal_position: 4, vertical_position: 2)
    knight = game.pieces.find_by(horizontal_position: 2, vertical_position: 1)
    black_king = game.pieces.find_by(type: 'King', color: 'black')
    white_king = game.pieces.find_by(type: 'King', color: 'white')

    it 'updates the piece\'s position if legal move' do
      pawn.move_to!(horizontal_position: 4, vertical_position: 4)
      knight.move_to!(horizontal_position: 3, vertical_position: 3)
      expect(pawn.vertical_position).to eq(4)
      expect(knight.horizontal_position).to eq(3)
      expect(knight.vertical_position).to eq(3)
    end

    it 'won\'t update the piece\'s position if illegal move' do
      pawn.move_to!(horizontal_position: 4, vertical_position: 6)
      knight.move_to!(horizontal_position: 3, vertical_position: 4)
      expect(pawn.vertical_position).to eq(4)
      expect(knight.horizontal_position).to eq(3)
      expect(knight.vertical_position).to eq(3)
    end

    it 'won\'t castle queenside if unable' do
      black_king.move_to!(horizontal_position: 3, vertical_position: 8)
      expect(black_king.horizontal_position).to eq(5)
    end

    it 'will castle queenside if able' do
      game.pieces.where(type: %w(Queen Bishop Knight)).delete_all
      black_king.move_to!(horizontal_position: 3, vertical_position: 8)
      expect(black_king.horizontal_position).to eq(3)
      black_rook = game.pieces.find_by(horizontal_position: 4, vertical_position: 8)
      expect(black_rook.type).to eq('Rook')
    end

    it 'won\'t castle kingside if unable' do
      black_king.move_to!(horizontal_position: 3, vertical_position: 8)
      expect(black_king.horizontal_position).to eq(3)
    end

    it 'will castle kingside if able' do
      game.pieces.where(type: %w(Queen Bishop Knight)).delete_all
      white_king.move_to!(horizontal_position: 7, vertical_position: 1)
      expect(white_king.horizontal_position).to eq(7)
      white_rook = game.pieces.find_by(horizontal_position: 6, vertical_position: 1)
      expect(white_rook.type).to eq('Rook')
    end

    it 'pawn will have passant true after moving 2 spaces' do
      white_pawn = FactoryGirl.create(:pawn, horizontal_position: 3, vertical_position: 2, color: 'white', game: game)
      white_pawn.move_to!(horizontal_position: 3, vertical_position: 4)
      expect(white_pawn.passant).to eq(true)
    end

    it 'pawn will not have passant true after moving one space' do
      white_pawn = FactoryGirl.create(:pawn, horizontal_position: 3, vertical_position: 2, color: 'white', game: game)
      white_pawn.move_to!(horizontal_position: 3, vertical_position: 3)
      expect(white_pawn.passant).to eq(false)
    end

    it 'pawn with passant true can be captured en passant' do
      FactoryGirl.create(:pawn, horizontal_position: 6, vertical_position: 4, color: 'white', game: game, passant: true)
      black_pawn = FactoryGirl.create(:pawn, horizontal_position: 5, vertical_position: 4, color: 'black', game: game)
      black_pawn.move_to!(horizontal_position: 6, vertical_position: 3)
      expect(black_pawn.horizontal_position).to eq(6)
      passant_pawn = game.pieces.find_by(horizontal_position: 6, vertical_position: 4)
      expect(passant_pawn.present?).to eq(false)
    end

    it 'pawn with passant false cannot be captured en passant' do
      FactoryGirl.create(:pawn, horizontal_position: 6, vertical_position: 4, color: 'white', game: game, passant: false)
      black_pawn = FactoryGirl.create(:pawn, horizontal_position: 5, vertical_position: 4, color: 'black', game: game)
      black_pawn.move_to!(horizontal_position: 6, vertical_position: 3)
      expect(black_pawn.horizontal_position).to eq(5)
      passant_pawn = game.pieces.find_by(horizontal_position: 6, vertical_position: 4)
      expect(passant_pawn.present?).to eq(true)
    end

    it 'moving another piece sets passant to false' do
      FactoryGirl.create(:pawn, horizontal_position: 6, vertical_position: 4, color: 'white', game: game, passant: true)
      black_pawn = FactoryGirl.create(:pawn, horizontal_position: 5, vertical_position: 4, color: 'black', game: game)
      black_pawn.move_to!(horizontal_position: 5, vertical_position: 3)
      expect(black_pawn.vertical_position).to eq(3)
      passant_pawn = game.pieces.find_by(horizontal_position: 6, vertical_position: 4)
      expect(passant_pawn.passant).to eq(false)
    end
  end
end
