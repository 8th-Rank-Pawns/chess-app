module PiecesHelper
  def capture!(new_x, new_y)
    if color != @chess_piece[:color]
      @chess_piece.update_attributes(horizontal_position: nil, vertical_position: nil)
      update_attributes(horizontal_position: new_x, vertical_position: new_y, castle: false)
    else
      false
    end
  end

  def can_castle?(new_x, new_y, color)
    return true if type == 'King' && new_y == vertical_position && castle_check(new_x, color)
    false
  end

  def obstructed?(x_end, y_end)
    @x_start = horizontal_position
    @y_start = vertical_position
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

  def horizontal_or_vertical?(x_end, y_end)
    horizontal_move = x_end != horizontal_position && y_end == vertical_position
    vertical_move = x_end == horizontal_position && y_end != vertical_position
    return true if horizontal_move || vertical_move
    false
  end

  def diagonal?(x_end, y_end)
    diff_x = (x_end - horizontal_position).abs
    diff_y = (y_end - vertical_position).abs
    return true if diff_y == diff_x
    false
  end

  def did_not_move?(x_end, y_end)
    return true if x_end == horizontal_position && y_end == vertical_position
  end

  private

  def horizontal_check
    if @x_end < @x_start
      (@x_end + 1..@x_start - 1).each do |x_between|
        return true if game.pieces.where(horizontal_position: x_between, vertical_position: @y_start).present?
      end
    else
      (@x_start + 1..@x_end - 1).each do |x_between|
        return true if game.pieces.where(horizontal_position: x_between, vertical_position: @y_start).present?
      end
    end
    false
  end

  def vertical_check
    if @y_end < @y_start
      (@y_end + 1..@y_start - 1).each do |y_between|
        return true if game.pieces.where(horizontal_position: @x_start, vertical_position: y_between).present?
      end
    else
      (@y_start + 1..@y_end - 1).each do |y_between|
        return true if game.pieces.where(horizontal_position: @x_start, vertical_position: y_between).present?
      end
    end
    false
  end

  def diagonal_check
    find_x_right_and_x_left
    count = 1
    while count < @x_right - @x_left
      return true if diagonal_direction && game.pieces.where(horizontal_position: @x_left + count, vertical_position: @y_bottom + count).present?
      return true if !diagonal_direction && game.pieces.where(horizontal_position: @x_left + count, vertical_position: @y_top - count).present?
      count += 1
    end
    false
  end

  def find_x_right_and_x_left
    @x_left = @x_start < @x_end ? @x_start : @x_end
    @x_right = @x_start < @x_end ? @x_end : @x_start
    @y_bottom = @y_start < @y_end ? @y_start : @y_end
    @y_top = @y_start < @y_end ? @y_end : @y_start
  end

  def diagonal_direction
    ((@x_right == @x_start && @y_top == @y_start) || (@x_left == @x_start && @y_bottom == @y_start))
  end
end
