require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe '.valid_move?' do
    let(:game) { FactoryGirl.create(:game) }
    let(:pawn) { FactoryGirl.create(:pawn, horizontal_position: 4, vertical_position: 2, color: 'white', game: game) }

    context 'when moves 1' do
      it { expect(pawn.valid_move?(4, 3)).to eq true }
    end

    context 'when moves backwards' do
      it { expect(pawn.valid_move?(4, 1)).to eq false }
    end

    context 'when moves 2 on first move' do
      it { expect(pawn.valid_move?(4, 4)).to eq true }
    end

    context 'when move is horizontal' do
      it { expect(pawn.valid_move?(3, 2)).to eq false }
    end

    context 'when move is diagonal no capture' do
      it { expect(pawn.valid_move?(3, 3)).to eq false }
    end

    context 'when pawn did not move' do
      it { expect(pawn.valid_move?(4, 2)).to eq false }
    end

    context 'when obstructed' do
      it 'obtructed returns true' do
        FactoryGirl.create(:pawn, horizontal_position: 4, vertical_position: 3, color: 'black', game: game)
        expect(pawn.valid_move?(4, 4)).to eq false
      end
    end

    context 'when there is a piece in front' do
      it 'piece in front returns true' do
        FactoryGirl.create(:pawn, horizontal_position: 4, vertical_position: 3, color: 'black', game: game)
        expect(pawn.valid_move?(4, 3)).to eq false
      end
    end

    context 'when diagonal capture' do
      it 'diagonal capture returns true' do
        FactoryGirl.create(:pawn, horizontal_position: 5, vertical_position: 3, color: 'black', game: game)
        expect(pawn.valid_move?(5, 3)).to eq true
      end
    end

    context 'when diagonal move where own piece present' do
      it 'diagonal capture does not return true' do
        FactoryGirl.create(:pawn, horizontal_position: 5, vertical_position: 3, color: 'white', game: game)
        expect(pawn.valid_move?(5, 3)).to eq false
      end
    end
  end

  describe '.valid_move?' do
    let(:game) { FactoryGirl.create(:game) }
    let(:pawn) { FactoryGirl.create(:pawn, horizontal_position: 7, vertical_position: 3, color: 'white', game: game) }

    context 'moves 2 when not first move' do
      it { expect(pawn.valid_move?(7, 5)).to eq false }
    end
  end

  describe '.valid_move?' do
    let(:game) { FactoryGirl.create(:game) }
    let(:pawn) { FactoryGirl.create(:pawn, horizontal_position: 4, vertical_position: 7, color: 'black', game: game) }

    context 'valid_move? for black' do
      it { expect(pawn.valid_move?(4, 6)).to eq true }
      it { expect(pawn.valid_move?(4, 5)).to eq true }
      it { expect(pawn.valid_move?(4, 7)).to eq false }
      it { expect(pawn.valid_move?(4, 8)).to eq false }
      it { expect(pawn.valid_move?(3, 7)).to eq false }
    end

    context 'when there is a piece in front' do
      it 'piece in front returns true' do
        FactoryGirl.create(:pawn, horizontal_position: 4, vertical_position: 6, color: 'black', game: game)
        expect(pawn.valid_move?(4, 6)).to eq false
      end
    end

    context 'when diagonal capture' do
      it 'diagonal capture returns true' do
        FactoryGirl.create(:pawn, horizontal_position: 5, vertical_position: 6, color: 'white', game: game)
        expect(pawn.valid_move?(5, 6)).to eq true
      end
    end
  end
end
