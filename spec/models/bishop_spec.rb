require 'rails_helper'

RSpec.describe Bishop, type: :model do
  describe '.valid_move?' do
    let(:game) { FactoryGirl.create(:game) }
    let(:bishop) { FactoryGirl.create(:bishop, horizontal_position: 3, vertical_position: 3, color: 'white', game: game) }

    context 'when bishop did not move' do
      it { expect(bishop.valid_move?(3, 3)).to eq false }
    end

    context 'when bishop moves diagonally up the board' do
      it { expect(bishop.valid_move?(5, 5)).to eq true }
    end

    context 'when bishop moves diagonally down the board' do
      it { expect(bishop.valid_move?(1, 1)).to eq true }
    end

    context 'when bishop moves illegally' do
      it { expect(bishop.valid_move?(3, 7)).to eq false }
    end

    context 'when obstructed' do
      it 'obstructed returns true' do
        FactoryGirl.create(:pawn, horizontal_position: 4, vertical_position: 4, color: 'black', game: game)
        expect(bishop.valid_move?(5, 5)).to eq false
      end
    end

    context 'when making a valid capture' do
      it 'valid capture' do
        FactoryGirl.create(:pawn, horizontal_position: 4, vertical_position: 4, color: 'black', game: game)
        expect(bishop.valid_move?(4, 4)).to eq true
      end
    end

    # should return false once capture logic is entered
    # context 'when making a move to square where piece of same color is present' do
    #   it 'valid capture' do
      #   FactoryGirl.create(:pawn, horizontal_position: 4, vertical_position: 4, color: 'white', game: game)
      #   expect(bishop.valid_move?(4, 4)).to eq false
      # end
    # end

  end
end