require 'rails_helper'

RSpec.describe Queen, type: :model do
  describe '.valid_move?' do
    let(:game) { FactoryGirl.create(:game) }
    let(:queen) { FactoryGirl.create(:queen, horizontal_position: 3, vertical_position: 3, color: 'white', game: game) }

    context 'when queen did not move' do
      it { expect(queen.valid_move?(3, 3)).to eq false }
    end

    context 'when queen moves up the board' do
      it { expect(queen.valid_move?(3, 7)).to eq true }
    end

    context 'when queen moves to the left on the board' do
      it { expect(queen.valid_move?(1, 3)).to eq true }
    end

    context 'when queen diagonally up up the board' do
      it { expect(queen.valid_move?(5, 5)).to eq true }
    end

    context 'when queen moves diagonally down the board' do
      it { expect(queen.valid_move?(1, 1)).to eq true }
    end

    context 'when queen moves illegally' do
      it { expect(queen.valid_move?(4, 5)).to eq false }
    end

    context 'when obstructed vertically' do
      it 'obstructed returns true' do
        FactoryGirl.create(:pawn, horizontal_position: 3, vertical_position: 4, color: 'black', game: game)
        expect(queen.valid_move?(3, 5)).to eq false
      end
    end

    context 'when obstructed diagonally' do
      it 'obstructed returns true' do
        FactoryGirl.create(:pawn, horizontal_position: 4, vertical_position: 4, color: 'black', game: game)
        expect(queen.valid_move?(5, 5)).to eq false
      end
    end

    context 'when making a valid capture' do
      it 'valid capture' do
        FactoryGirl.create(:pawn, horizontal_position: 4, vertical_position: 4, color: 'black', game: game)
        expect(queen.valid_move?(4, 4)).to eq true
      end
    end

    # should return false once capture logic is entered
    # context 'when making a move to square where piece of same color is present' do
    #   it 'move on same color' do
    #     FactoryGirl.create(:pawn, horizontal_position: 3, vertical_position: 4, color: 'white', game: game)
    #     expect(queen.valid_move?(3, 4)).to eq false
    #   end
    # end
  end
end
