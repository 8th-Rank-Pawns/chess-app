class Rook < Piece
  def valid_move?(x_end, y_end)
    return false if same_color?(x_end, y_end) || obstructed?(x_end, y_end) || did_not_move?(x_end, y_end)
    return true if horizontal_or_vertical?(x_end, y_end)
    false
  end
end
