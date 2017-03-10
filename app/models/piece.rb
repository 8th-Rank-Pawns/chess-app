class Piece < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  include PiecesHelper

  def move_to!(params)
    new_x = params[:horizontal_position].to_i
    new_y = params[:vertical_position].to_i
    @chess_piece = game.pieces.find_by(horizontal_position: new_x, vertical_position: new_y)
    enemy_pawn = pawn_location(color, new_x, vertical_position)
    if capture?(new_x, new_y)
      capture!(new_x, new_y)
    elsif double_move?(type, vertical_position, new_x, new_y)
      update_it!(new_x, new_y)
      update_attributes(passant: true)
    elsif valid_move?(new_x, new_y)
      passant_capture!(enemy_pawn, type)
      update_it!(new_x, new_y)
    elsif can_castle?(new_x, new_y, color)
      perform_castling(new_x, color)
    else
      false
    end
  end

  def pawn_location(color, new_x, vertical_position)
    if color == 'white'
      game.pieces.find_by(type: 'Pawn', horizontal_position: new_x, vertical_position: vertical_position, color: 'black')
    else
      game.pieces.find_by(type: 'Pawn', horizontal_position: new_x, vertical_position: vertical_position, color: 'white')
    end
  end

  def update_it!(new_x, new_y)
    update_attributes(horizontal_position: new_x, vertical_position: new_y, castle: false)
    game.pieces.update_all(passant: false)
  end

  def capture?(new_x, new_y)
    @chess_piece && valid_move?(new_x, new_y)
  end

  def double_move?(type, vertical_position, new_x, new_y)
    valid_move?(new_x, new_y) && type == 'Pawn' && ((vertical_position == 2 && new_y == 4) || (vertical_position == 7 && new_y == 5))
  end

  def passant_capture!(enemy_pawn, type)
    enemy_pawn.destroy if type == 'Pawn' && enemy_pawn.present? && enemy_pawn[:passant] == true
  end
end
