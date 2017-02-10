class Piece < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
# Every time a piece is moved the "valid_move?" method is called which should call the "is_obstructed?" method and pass it x_end & y_end.
# If is_obstructed returns false, move is legal.
# Will write tests later after moving pieces action is more clear...
  def horizontal_check
    if @x_end < @x_start
      (@x_end + 1..@x_start - 1).each do |x_between|
        return true if game.pieces.where(horizontal_position: x_between).present?
      end
    else
      (@x_start + 1..@x_end - 1).each do |x_between|
        return true if game.pieces.where(horizontal_position: x_between).present?
      end
    end
    false
  end

  def vertical_check(@x_end, @y_end)
    if @y_end < @y_start
      (@y_end + 1..@y_start - 1).each do |y_between|
        return true if game.pieces.where(vertical_position: y_between).present?
      end
    else
      (@y_start + 1..@y_end - 1).each do |y_between|
        return true if game.pieces.where(vertical_position: y_between).present?
      end
    end
    false
  end

  def diagonal_check
    x_left = @x_start < @x_end ? @x_start : @x_end
    x_right = @x_start < @x_end ? @x_end : x_start
    count = 1
    while count < x_right - x_left
      if @y_end > @y_start
        return true if game.pieces.where(horizontal_position: x_left + count, vertical_position: @y_start + count).present?
      else
        return true if game.pieces.where(horizontal_position: x_left + count, vertical_position: @y_start - count).present?
      end
      count += 1
    end
  end

  def obstructed?(x_end, y_end)
    @x_start = self.horizontal_position
    @y_start = self.vertical_position
    @x_end = x_end
    @y_end = y_end
    if x_end == @x_start
      vertical_check
    elsif y_end == @y_start
      horizontal_check
    elsif ((y_end - @y_start) / (x_end - @x_start)).abs == 1
      diagonal_check
    else
      false
    end
  end
end
