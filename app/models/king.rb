class King < Piece
  def valid_move? (x_end, y_end)
    piece = Piece.find(self.id)
    x_start = piece.x_coord
    y_start =  piece.y_coord
    if x_end == x_start && y_end == y_start
        return false
    elsif x_end == x_start || x_end == x_start-1 || x_end == x_start+1
      if y_end == y_start || y_end == y_start-1 || y_end == y_start+1
        return true
      end
    else
      return false
    end
  end
end
