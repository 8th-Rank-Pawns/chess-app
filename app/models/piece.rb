class Piece < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
# Every time one of these pieces is moved the "valid_move?" method should be called and that should call the "is_obstructed?" method.
# game.pieces.where(horizontal_position & vertical_position) are extracted current location of pieces on game board.
# If is_obstructed returns false, move is legal.
# x_end & y_end values are filled when piece is moved.
# Will write tests later after moving pieces action is more clear...
  def horizontal_check(x_end, y_end)
    if x_end < x_start
      (x_end + 1..x_start - 1).each do |x_between|
        return true if game.pieces.where(horizontal_position: x_between).present?
      end
    else
      (x_start + 1..x_end - 1).each do |x_between|
        return true if game.pieces.where(horizontal_position: x_between).present?
      end
    end
    false
  end

  def vertical_check(x_end, y_end)
    if y_end < y_start
      (y_end + 1..y_start - 1).each do |y_between|
        return true if game.pieces.where(vertical_position: y_between).present?
      end
    else
      (y_start + 1..y_end - 1).each do |y_between|
        return true if game.pieces.where(vertical_position: y_between).present?
      end
    end
    false
  end

  def diagonal_check(x_end, y_end)
    x_left = x_start < x_end ? x_start : x_end
    x_right = x_start < x_end ? x_end : x_start
    count = 1
    while count < x_right - x_left
      if y_end > y_start
        return true if game.pieces.where(horizontal_position: x_left + count, vertical_position: y_start + count).present?
      else
        return true if game.pieces.where(horizontal_position: x_left + count, vertical_position: y_start - count).present?
      end
      count += 1
    end
  end

  def obstructed?(x_end, y_end)
    x_start = Piece.horizontal_position
    y_start = Piece.vertical_position
    if x_end == x_start
      vertical_check(x_end, y_end)
    elsif y_end == y_start
      horizontal_check(x_end, y_end)
    elsif ((y_end - y_start) / (x_end - x_start)).abs == 1
      diagonal_check(x_end, y_end)
    else
      false
    end
  end
end
