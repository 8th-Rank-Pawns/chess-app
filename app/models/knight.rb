class Knight < Piece
  def valid_move?(x_end, y_end)
    return false if same_color?(x_end, y_end) 
    variant_one = (x_end - horizontal_position).abs == 1 && (y_end - vertical_position).abs == 2
    variant_two = (x_end - horizontal_position).abs == 2 && (y_end - vertical_position).abs == 1
    return true if variant_one || variant_two
    false
  end
end
