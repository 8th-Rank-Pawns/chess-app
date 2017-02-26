class King < Piece
  def valid_move?(x_end, y_end)
    too_far = (x_end - horizontal_position).abs > 1 || (y_end - horizontal_position).abs > 1
    return true unless did_not_move?(x_end, y_end) || too_far || move_to_check?(x_end, y_end)
    false
  end
end
