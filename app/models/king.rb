class King < Piece
  def valid_move?(x_end, y_end)
    too_far = (x_end - horizontal_position).abs > 1 || (y_end - vertical_position).abs > 1
    return true unless did_not_move?(x_end, y_end) || too_far
    false
  end

  def castle_check(new_x, color)
    define_rooks
    # Need "prevent yourself from moving into check" method to cover the remaining restrictions
    return true if new_x == 3 && which_side_castle_check(color, 'queen')
    return true if new_x == 7 && which_side_castle_check(color, 'king')
    false
  end

  def which_side_castle_check(color, side)
    rook = instance_variable_get("@#{color}_#{side}_rook")
    return true if castle && !rook.nil? && rook.castle && !obstructed?(rook.horizontal_position, rook.vertical_position) && game.check?(color) == false
    false
  end

  def perform_castling(new_x, color)
    define_rooks
    update_attributes(horizontal_position: new_x, castle: false)
    game.pieces.update_all(passant: false)
    return perform_queenside_castling(color) if new_x == 3
    return perform_kingside_castling(color) if new_x == 7
  end

  def perform_queenside_castling(color)
    rook = instance_variable_get("@#{color}_queen_rook")
    rook.update_attributes(horizontal_position: 4, castle: false)
  end

  def perform_kingside_castling(color)
    rook = instance_variable_get("@#{color}_king_rook")
    rook.update_attributes(horizontal_position: 6, castle: false)
  end

  def define_rooks
    @white_queen_rook = game.pieces.find_by(horizontal_position: 1, vertical_position: 1, type: 'Rook')
    @white_king_rook = game.pieces.find_by(horizontal_position: 8, vertical_position: 1, type: 'Rook')
    @black_queen_rook = game.pieces.find_by(horizontal_position: 1, vertical_position: 8, type: 'Rook')
    @black_king_rook = game.pieces.find_by(horizontal_position: 8, vertical_position: 8, type: 'Rook')
  end
end
