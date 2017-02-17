class Pawn < Piece
  def valid_move?(x_end, y_end)
    diff_x = (horizontal_position - x_end).abs
    diff_y = y_end - vertical_position if color == 'white'
    diff_y = vertical_position - y_end if color == 'black'

    return false if obstructed?(x_end, y_end) || did_not_move?(x_end, y_end)
    return false if piece_in_front?(x_end, y_end, diff_x, diff_y)
    return true if diff_y == 1 && diff_x.zero?
    return true if diff_y == 2 && first_move? && diff_x.zero?
    return true if diagonal_capture?(x_end, y_end, diff_x, diff_y)
    false
  end

  private

  def piece_in_front?(x_end, y_end, diff_x, diff_y)
    return true if diff_y == 1 && diff_x.zero? && game.pieces.where(horizontal_position: x_end, vertical_position: y_end).present?
  end

  def diagonal_capture?(x_end, y_end, diff_x, diff_y)
    return true if color == 'white' && diagonal_move(diff_x, diff_y) && game.pieces.where(horizontal_position: x_end, vertical_position: y_end, color: 'black').present?
    return true if color == 'black' && diagonal_move(diff_x, diff_y) && game.pieces.where(horizontal_position: x_end, vertical_position: y_end, color: 'white').present?
  end

  def diagonal_move(diff_x, diff_y)
    return true if diff_x == 1 && diff_y == 1
  end

  def first_move?
    return true if (vertical_position == 2 && color == 'white') || (vertical_position == 7 && color == 'black')
  end
end
