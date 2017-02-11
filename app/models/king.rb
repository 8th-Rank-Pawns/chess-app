class King < Piece
  def valid_move? (x_end, y_end)
    x_start = horizontal_position
    y_start = vertical_position
    if (x_end == x_start && y_end == y_start) || (x_end - x_start).abs > 1) || (y_end - y_start).abs > 1)
      return false
    else
      return true
    end
  end
end