class King < Piece
  def valid_move?(x_end, y_end)
    did_not_move = x_end == horizontal_position && y_end == vertical_position
    too_far = (x_end - horizontal_position).abs > 1 || (y_end - horizontal_position).abs > 1
    return true unless did_not_move || too_far
    false
  end
end
