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

    # should return false once capture logic is entered
    # context 'when making a move to square where piece of same color is present' do
    #   it 'move on same color' do
    #     FactoryGirl.create(:pawn, horizontal_position: 3, vertical_position: 4, color: 'white', game: game)
    #     expect(king.valid_move?(3, 4)).to eq false
    #   end
    # end
  end
end
