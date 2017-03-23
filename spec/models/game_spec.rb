require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'king check method working correctly' do
    it 'returns true when game is in check' do
      game = FactoryGirl.create(:game)
      FactoryGirl.create(:king, horizontal_position: 5, vertical_position: 5, color: 'white', game: game)
      FactoryGirl.create(:bishop, horizontal_position: 3, vertical_position: 3, color: 'black', game: game)
      expect(game.check?('white')).not_to eq false
    end

    it 'returns false when game is not in check' do
      game = FactoryGirl.create(:game)
      FactoryGirl.create(:king, horizontal_position: 5, vertical_position: 5, color: 'white', game: game)
      FactoryGirl.create(:bishop, horizontal_position: 3, vertical_position: 4, color: 'black', game: game)
      expect(game.check?('white')).to eq false
    end
  end

  describe 'stalemate method working correctly' do
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
