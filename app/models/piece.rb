class Piece < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  include PiecesHelper

  def move_to!(params)
    new_x = params[:horizontal_position].to_i
    new_y = params[:vertical_position].to_i
    @chess_piece = game.pieces.find_by(horizontal_position: new_x, vertical_position: new_y)
    if @chess_piece && valid_move?(new_x, new_y)
      capture!(new_x, new_y)
    elsif valid_move?(new_x, new_y)
      update_attributes(horizontal_position: new_x, vertical_position: new_y, castle: false)
    elsif can_castle?(new_x, new_y, color)
      perform_castling(new_x, color)
    else
      false
    end
  end
end
