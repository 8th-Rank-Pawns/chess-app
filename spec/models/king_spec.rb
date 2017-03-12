require 'rails_helper'

RSpec.describe King, type: :model do
  describe '.valid_move?' do
    let(:game) { FactoryGirl.create(:game) }
    let(:king) { FactoryGirl.create(:king, horizontal_position: 3, vertical_position: 3, color: 'white', game: game) }

    context 'when king did not move' do
      it { expect(king.valid_move?(3, 3)).to eq false }
    end

    context 'when king moves up the board' do
      it { expect(king.valid_move?(3, 4)).to eq true }
    end

    context 'when king moves down the board' do
      it { expect(king.valid_move?(3, 2)).to eq true }
    end

    context 'when king moves diagonally' do
      it { expect(king.valid_move?(4, 4)).to eq true }
    end

    context 'when king moves more than 1 space' do
      it { expect(king.valid_move?(3, 5)).to eq false }
    end

    context 'when making a valid capture' do
      it 'valid capture' do
        FactoryGirl.create(:pawn, horizontal_position: 3, vertical_position: 4, color: 'black', game: game)
        expect(king.valid_move?(3, 4)).to eq true
      end
    end
  end

  describe '.move_into_check?' do
    game = FactoryGirl.create(:game)
    black_king = FactoryGirl.create(:king, horizontal_position: 5, vertical_position: 8, color: 'black', game: game)

    it 'move_into_check is false when king doesn\'t move into check' do
      expect(black_king.move_into_check?(5, 7, black_king.horizontal_position, black_king.vertical_position)).to eq false
    end

    it 'move_into_check is true when king moves into check' do
      FactoryGirl.create(:bishop, horizontal_position: 8, vertical_position: 4, color: 'white', game: game)
      expect(black_king.move_into_check?(5, 7, black_king.horizontal_position, black_king.vertical_position)).to eq true
    end

    it 'move_into_check is false if piece is blocking attacker' do
      FactoryGirl.create(:bishop, horizontal_position: 8, vertical_position: 4, color: 'white', game: game)
      FactoryGirl.create(:pawn, horizontal_position: 7, vertical_position: 5, color: 'white', game: game)
      expect(black_king.move_into_check?(5, 7, black_king.horizontal_position, black_king.vertical_position)).to eq false
    end

    it 'move_into_check doesn\'t allow pieces blocking king from attacker to be moved so that king becomes checked' do
      FactoryGirl.create(:bishop, horizontal_position: 8, vertical_position: 5, color: 'white', game: game)
      pawn = FactoryGirl.create(:pawn, horizontal_position: 7, vertical_position: 6, color: 'black', game: game)
      expect(pawn.move_into_check?(7, 5, pawn.horizontal_position, pawn.vertical_position)).to eq true
    end
  end

  describe '.can_castle?' do
    context 'returns true when castling is legal' do
      game = FactoryGirl.create(:game)
      game.populate_board!
      game.pieces.where(type: %w(Queen Bishop Knight)).delete_all
      black_king = game.pieces.find_by(type: 'King', color: 'black')
      white_king = game.pieces.find_by(type: 'King', color: 'white')

      it 'black can castle queenside' do
        expect(black_king.can_castle?(3, 8, 'black')).to eq(true)
      end

      it 'black can castle kingside' do
        expect(black_king.can_castle?(7, 8, 'black')).to eq(true)
      end

      it 'white can castle queenside' do
        expect(white_king.can_castle?(3, 1, 'white')).to eq(true)
      end

      it 'white can castle kingside' do
        expect(white_king.can_castle?(7, 1, 'white')).to eq(true)
      end
    end

    context 'returns false when castling is illegal' do
      game = FactoryGirl.create(:game)
      game.populate_board!
      black_king = game.pieces.find_by(type: 'King', color: 'black')
      white_king = game.pieces.find_by(type: 'King', color: 'white')
      white_rook = game.pieces.find_by(horizontal_position: 8, vertical_position: 1)

      it 'has pieces in the way' do
        expect(black_king.can_castle?(3, 8, 'black')).to eq(false)
        expect(black_king.can_castle?(7, 8, 'black')).to eq(false)
        expect(white_king.can_castle?(3, 1, 'white')).to eq(false)
        expect(white_king.can_castle?(7, 1, 'white')).to eq(false)
      end

      it 'king has moved from it\'s starting position prior to castling attempt' do
        game.pieces.where(type: %w(Queen Bishop Knight)).delete_all
        expect(black_king.can_castle?(3, 8, 'black')).to eq(true)
        black_king.move_to!(horizontal_position: 4, vertical_position: 8)
        black_king.move_to!(horizontal_position: 5, vertical_position: 8)
        expect(black_king.can_castle?(3, 8, 'black')).to eq(false)
      end

      it 'rook has moved from it\'s starting position prior to castling attempt' do
        game.pieces.where(type: %w(Queen Bishop Knight)).delete_all
        expect(white_king.can_castle?(7, 1, 'white')).to eq(true)
        white_rook.move_to!(horizontal_position: 6, vertical_position: 1)
        white_rook.move_to!(horizontal_position: 8, vertical_position: 1)
        expect(white_king.can_castle?(7, 1, 'white')).to eq(false)
      end

      it 'king is in check' do
        game.pieces.where(type: %w(Queen Bishop Knight)).delete_all
        FactoryGirl.create(:knight, horizontal_position: 6, vertical_position: 3, color: 'black', game: game)
        expect(white_king.can_castle?(3, 1, 'white')).to eq(false)
        expect(white_king.can_castle?(7, 1, 'white')).to eq(false)
      end
    end
  end
end
