require 'rails_helper'

RSpec.describe Knight, type: :model do
  describe '.valid_move?' do
    let(:game) { FactoryGirl.create(:game) }
    let(:knight) { FactoryGirl.create(:knight, horizontal_position: 4, vertical_position: 5, color: 'white', game: game) }

    context 'when knight did not move' do
      it { expect(knight.valid_move?(4, 5)).to eq false }
    end

    context 'when moves 2 to the right and 1 up (Q1 of the quadrant wrt to original position' do
      it { expect(knight.valid_move?(6, 6)).to eq true }
    end

    context 'when moves 1 to the left and 2 down (Q3 of the quadrant wrt to original position)' do
      it { expect(knight.valid_move?(3, 3)).to eq true }
    end

    context 'when moves 1 up and 2 left (Q2 of the quadrant wrt to original position)' do
      it { expect(knight.valid_move?(5, 3)).to eq true }
    end

    context 'when moves 1 to the left and 1 to the right (invalid move)' do
      it { expect(knight.valid_move?(5, 6)).to eq false }
    end

    context 'when obstructed' do
      it 'obstructed returns true' do
        FactoryGirl.create(:pawn, horizontal_position: 4, vertical_position: 4, color: 'black', game: game)
        expect(knight.valid_move?(3, 3)).to eq true
      end
    end

    context 'when making a valid capture' do
      it 'valid capture' do
        FactoryGirl.create(:pawn, horizontal_position: 3, vertical_position: 3, color: 'black', game: game)
        expect(knight.valid_move?(3, 3)).to eq true
      end
    end

    # should return false once capture logic is entered
    # context 'when making a move to square where piece of same color is present' do
    #   it 'same color returns false' do
    #     FactoryGirl.create(:pawn, horizontal_position: 3, vertical_position: 3, color: 'white', game: game)
    #     expect(knight.valid_move?(3, 3)).to eq false
    #   end
    # end

  end
end