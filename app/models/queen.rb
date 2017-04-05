class Queen < Piece
  def valid_move?(x_end, y_end)
    super(x_end, y_end)
    return false if obstructed?(x_end, y_end) || did_not_move?(x_end, y_end)
    return true if horizontal_or_vertical?(x_end, y_end) || diagonal?(x_end, y_end)
    false
  end
end
