require 'rails_helper'

RSpec.describe Rook, type: :model do
  describe '.valid_move?' do
    let(:game) { FactoryGirl.create(:game) }
    let(:rook) { FactoryGirl.create(:rook, horizontal_position: 3, vertical_position: 3, color: 'white', game: game) }

    context 'when rook did not move' do
      it { expect(rook.valid_move?(3, 3)).to eq false }
    end

    context 'when rook moves up the board' do
      it { expect(rook.valid_move?(3, 7)).to eq true }
    end

    context 'when rook moves down the board' do
      it { expect(rook.valid_move?(3, 1)).to eq true }
    end

    context 'when rook moves to the right on the board' do
      it { expect(rook.valid_move?(7, 3)).to eq true }
    end

    context 'when rook moves illegally' do
      it { expect(rook.valid_move?(5, 5)).to eq false }
    end

    context 'when obstructed' do
      it 'obstructed returns true' do
        FactoryGirl.create(:pawn, horizontal_position: 3, vertical_position: 4, color: 'black', game: game)
        expect(rook.valid_move?(3, 5)).to eq false
      end
    end

    context 'when making a valid capture' do
      it 'valid capture' do
        FactoryGirl.create(:pawn, horizontal_position: 3, vertical_position: 4, color: 'black', game: game)
        expect(rook.valid_move?(3, 4)).to eq true
      end
    end

    # should return false once capture logic is entered
    # context 'when making a move to square where piece of same color is present' do
    #   it 'move on same color' do
    #     FactoryGirl.create(:pawn, horizontal_position: 3, vertical_position: 4, color: 'white', game: game)
    #     expect(rook.valid_move?(3, 4)).to eq false
    #   end
    # end
  end
end
