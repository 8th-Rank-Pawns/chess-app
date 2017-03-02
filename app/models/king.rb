class King < Piece
  def valid_move?(x_end, y_end)
    too_far = (x_end - horizontal_position).abs > 1 || (y_end - vertical_position).abs > 1
    return true unless did_not_move?(x_end, y_end) || too_far
    false
  end

  def castle_check(new_x, color)
    define_rooks
    # Need "prevent yourself from moving into check" method to cover the remaining restrictions
    return true if new_x == 3 && queen_side_castle_check(color)
    return true if new_x == 7 && king_side_castle_check(color)
    false
  end

  def queen_side_castle_check(color)
    rook = instance_variable_get("@#{color}_queen_rook")
    return true if castle && !rook.nil? && rook.castle && !obstructed?(rook.horizontal_position, rook.vertical_position) && game.check?(color) == false
    false
  end

  def king_side_castle_check(color)
    rook = instance_variable_get("@#{color}_king_rook")
    return true if castle && !rook.nil? && rook.castle && !obstructed?(rook.horizontal_position, rook.vertical_position) && game.check?(color) == false
    false
  end

  def perform_castling(new_x)
    define_rooks

    update_attributes(horizontal_position: new_x, castle: false)
    return @white_queen_rook.update_attributes(horizontal_position: 4, castle: false) if new_x == 3 && color == 'white'
    return @white_king_rook.update_attributes(horizontal_position: 6, castle: false) if new_x == 7 && color == 'white'
    return @black_queen_rook.update_attributes(horizontal_position: 4, castle: false) if new_x == 3 && color == 'black'
    return @black_king_rook.update_attributes(horizontal_position: 6, castle: false) if new_x == 7 && color == 'black'
  end

  def define_rooks
    @white_queen_rook = game.pieces.find_by(horizontal_position: 1, vertical_position: 1, type: 'Rook')
    @white_king_rook = game.pieces.find_by(horizontal_position: 8, vertical_position: 1, type: 'Rook')
    @black_queen_rook = game.pieces.find_by(horizontal_position: 1, vertical_position: 8, type: 'Rook')
    @black_king_rook = game.pieces.find_by(horizontal_position: 8, vertical_position: 8, type: 'Rook')
  end
end
