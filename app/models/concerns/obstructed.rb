# In queen.rb, rook.rb, bishop.rb, pawn.rb, I added "include Obstructed"
# Every time one of these pieces is moved the "valid_move?" method should be called
# and that should call the "is_obstructed?" method.
# game.pieces.where(horizontal_position & vertical_position) are extracted current location of pieces on game board.
# If is_obstructed returns false, move is legal.
# x_start, x_end, y_start, y_end values are filled when piece is moved.
# Will write tests later after moving pieces action is more clear...
module Obstructed
  def horizontal_check
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

  def vertical_check
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

  def diagonal_check
    count = 1
    if x_end > x_start
      while count < (x_end - x_start)
        if y_end > y_start
          return true if game.pieces.where(horizontal_position: x_start + count, vertical_position: y_start + count).present?
        else
          return true if game.pieces.where(horizontal_position: x_start + count, vertical_position: y_start - count).present?
        end
        count += 1
      end
    else
      while count < (x_start - x_end)
        if y_end > y_start
          return true if game.pieces.where(horizontal_position: x_start - count, vertical_position: y_start + count).present?
        else
          return true if game.pieces.where(horizontal_position: x_start - count, vertical_position: y_start - count).present?
        end
        count += 1
      end
    end
    false
  end

  def obstructed?(x_start, y_start, x_end, y_end)
    if x_end == x_start
      vertical_check
    elsif y_end == y_start
      horizontal_check
    elsif ((y_end - y_start) / (x_end - x_start)).abs == 1
      diagonal_check
    else
      false
    end
  end
end
