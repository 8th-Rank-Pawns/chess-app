class King < Piece
  def valid_move?(x_end, y_end)
    too_far = (x_end - horizontal_position).abs > 1 || (y_end - horizontal_position).abs > 1
    def move_to_check?(x_end, y_end)
      game.pieces.where(!color).each do |piece| #need proper notation for pieces of opposite color
        return true if piece.valid_move?(x_end, y_end)
      end
      false
    end
    return true unless did_not_move?(x_end, y_end) || too_far || move_to_check?(x_end, y_end)
    false
  end
end
