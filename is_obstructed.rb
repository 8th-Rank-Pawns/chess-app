#This file goes in the app>models>concerns folder
#In queen.rb, rook.rb, bishop.rb, pawn.rb need to add --> include Obstructed
#game.pieces.where(x_value & y_value) are extracted current location of pieces on game board.
#if is_obstructed returns false, move is valid.
module Obstructed
  def horizontal_check
    if x_end < x_start
      (x_end+1..x_start-1).each do |x_between|
        return true if game.pieces.where(x_value: x_between).present?
      end
    else
      (x_start+1..x_end-1).each do |x_between|
        return true if game.pieces.where(x_value: x_between).present?
      end
    end
    return false
  end

  def vertical_check
    if y_end < y_start
      (y_end+1..y_start-1).each do |y_between|
        return true if game.pieces.where(y_value: y_between).present?
      end
    else
      (y_start+1..y_end-1).each do |y_between|
        return true if game.pieces.where(y_value: y_between).present?
      end
    end
    return false
  end

  def diagonal_check
    count = 1
    if x_end > x_start
      while count < (x_end - x_start)
        if y_end > y_start
          return true if game.pieces.where(x_value: x_start+count, y_value: y_start+count).present?
        else
          return true if game.pieces.where(x_value: x_start+count, y_value: y_start-count).present?
        end
        count += 1
      end
    else
      while count < (x_start - x_end)
        if y_end > y_start
          return true if game.pieces.where(x_value: x_start-count, y_value: y_start+count).present?
        else
          return true if game.pieces.where(x_value: x_start-count, y_value: y_start-count).present?
        end
        count += 1
      end
    end
    return false
  end

  def is_obstructed?(x_start, y_start, x_end, y_end)
    if x_end == x_start
      return vertical_check
    elsif y_end == y_start
      return horizontal_check
    elsif ((y_end-y_start)/(x_end-x_start)).abs == 1
      return diagonal_check
    else return false
    end
  end
end