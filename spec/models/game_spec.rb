require 'rails_helper'

RSpec.describe Game, type: :model do
  # describe 'is king in check?' do
  #   let(:game) { FactoryGirl.create(:game) }
  #   let(:king) { FactoryGirl.create(:king, horizontal_position: 5, vertical_position: 5, color: 'white', game: game) }

  #   context 'when in check' do
  #     it 'returns true when king is in check' do
  #       FactoryGirl.create(:bishop, horizontal_position: 3, vertical_position: 3, color: 'black', game: game)
  #       expect(game.check?('white')).to eq true
  #     end
  #   end

  #   context 'when not in check' do
  #     it 'returns false when king is not in check' do
  #       FactoryGirl.create(:bishop, horizontal_position: 3, vertical_position: 4, color: 'black', game: game)
  #       expect(game.check?('white')).to eq false
  #     end
  #   end

  # end
end
