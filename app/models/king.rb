class King < Piece
  def valid_move?(x_end, y_end)
    return true unless (x_end == horizontal_position && y_end == vertical_position) || (x_end - horizontal_position).abs > 1 || (y_end - horizontal_position).abs > 1
  end
end
