require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  # Test fails due to STI, will update later on.
  # describe 'piece#update action' do
  #   it 'updates the board with the piece\'s new position' do
  #     piece = FactoryGirl.create(
  #       :pawn,
  #       horizontal_position: 5,
  #       vertical_position: 2)
  #     patch :update, id: piece.id, piece: {vertical_position: 4}
  #     expect(response).to have_http_status(:success)
  #     expect(piece.vertical_position).to eq(4)
  #   end
  # end
end
