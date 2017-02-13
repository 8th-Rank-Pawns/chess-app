class Rook < Piece
  def valid_move?(x_end, y_end)
    return false if obstructed?(x_end, y_end)
    return true if is_horizontal_or_vertical?(x_end, y_end)
    false
  end
end
