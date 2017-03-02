class King < Piece
  def valid_move?(x_end, y_end)
    too_far = (x_end - horizontal_position).abs > 1 || (y_end - vertical_position).abs > 1
    return true unless did_not_move?(x_end, y_end) || too_far
    false
  end

  def can_castle(new_x, new_y)
    define_rooks
    # Need the prevent yourself from moving into check method to cover the remaining restrictions
    return true if self.castle && self.color == 'white' && @white_queen_rook.castle && new_x == 3 && new_y == 1 && !obstructed?(1, new_y) && self.game.check?('white') == false
    return true if self.castle && self.color == 'white' && @white_king_rook.castle && new_x == 7 && new_y == 1 && !obstructed?(8, new_y) && self.game.check?('white') == false
    return true if self.castle && self.color == 'black' && @black_queen_rook.castle && new_x == 3 && new_y == 8 && !obstructed?(1, new_y) && self.game.check?('black') == false
    return true if self.castle && self.color == 'black' && @black_king_rook.castle && new_x == 7 && new_y == 8 && !obstructed?(8, new_y) && self.game.check?('black') == false
    return false
  end

  def perform_castling(new_x)
    define_rooks
    self.update_attributes(horizontal_position: new_x, castle: false)
    if new_x == 3 && self.color == 'white'
      @white_queen_rook.update_attributes(horizontal_position: 4, castle: false)
    elsif new_x == 7 && self.color == 'white'
      @white_king_rook.update_attributes(horizontal_position: 6, castle: false)
    elsif new_x == 3 && self.color == 'black'
      @black_queen_rook.update_attributes(horizontal_position: 4, castle: false)
    else
      @black_king_rook.update_attributes(horizontal_position: 6, castle: false)
    end
  end

  def define_rooks
    current_game_pieces = self.game.pieces
    @white_queen_rook = current_game_pieces.find_by(horizontal_position: 1, vertical_position: 1, type: 'Rook')
    @white_king_rook = current_game_pieces.find_by(horizontal_position: 8, vertical_position: 1, type: 'Rook')
    @black_queen_rook = current_game_pieces.find_by(horizontal_position: 1, vertical_position: 8, type: 'Rook')
    @black_king_rook = current_game_pieces.find_by(horizontal_position: 8, vertical_position: 8, type: 'Rook')
  end

end
