class Piece < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  # Every time a piece is moved the "valid_move?" method is called which should call the "is_obstructed?" method and pass it x_end & y_end.
  # If is_obstructed returns false, move is legal.
  # Will write tests after moving pieces action is more clear.
  def move_to!(params)
    new_x = params[:horizontal_position].to_i
    new_y = params[:vertical_position].to_i
    # Set an enemy_piece so that the code references the same piece throughout the method.
    enemy_piece = game.pieces.where(horizontal_position: new_x, vertical_position: new_y).first
    # Step 1: Check to see if a piece occupies the new location.
    if enemy_piece.present? && valid_move?(new_x, new_y)
      # Step 2: Check to see if the piece is of the oppposite color.
      if color != enemy_piece[:color]
        # Step 3: Remove piece from the board.
        enemy_piece.update_attributes(horizontal_position: nil, vertical_position: nil)
        # Update Piece position to new_x, new_y
        update_attributes(horizontal_position: new_x, vertical_position: new_y)
        # Is game in check?
        check?(color)
      else
        # If the piece is the same color, then alert the user that the move is invalid.
        false
      end
    elsif valid_move?(new_x, new_y)
      update_attributes(horizontal_position: new_x, vertical_position: new_y)
      # Is game in check?
      check?(color)
    else
      false
    end
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
