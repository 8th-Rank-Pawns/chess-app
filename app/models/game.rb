class Game < ActiveRecord::Base
  scope :available, -> { where('black_player IS NULL OR white_player IS NULL') }
  has_many :users
  has_many :pieces

  def populate_board!
    [[1, 'white'], [8, 'black']].each do |x|
      King.create(horizontal_position: 5, vertical_position: x[0], color: x[1], game_id: id, castle: true)
      Queen.create(horizontal_position: 4, vertical_position: x[0], color: x[1], game_id: id)
      Bishop.create(horizontal_position: 3, vertical_position: x[0], color: x[1], game_id: id)
      Bishop.create(horizontal_position: 6, vertical_position: x[0], color: x[1], game_id: id)
      Knight.create(horizontal_position: 2, vertical_position: x[0], color: x[1], game_id: id)
      Knight.create(horizontal_position: 7, vertical_position: x[0], color: x[1], game_id: id)
      Rook.create(horizontal_position: 1, vertical_position: x[0], color: x[1], game_id: id, castle: true)
      Rook.create(horizontal_position: 8, vertical_position: x[0], color: x[1], game_id: id, castle: true)
    end
    count = 1
    while count <= 8
      Pawn.create(horizontal_position: count, vertical_position: 2, color: 'white', game_id: id)
      Pawn.create(horizontal_position: count, vertical_position: 7, color: 'black', game_id: id)
      count += 1
    end
  end

  def checkmate!(color)
    return true if check?(color) == 'in check & no blockers'# && king_cant_move(color)
  end

  def check?(color)
    @king = King.find_by(game: self, color: color)
    @attackers = []
    Piece.where(game: self).where.not(color: color).each do |piece|
      @attackers << piece if piece.valid_move?(@king.horizontal_position, @king.vertical_position)
    end
    return false if @attackers.empty?
    can_attackers_be_killed_or_their_path_to_your_king_be_obstructed?
  end

  def can_attackers_be_killed_or_their_path_to_your_king_be_obstructed?
    defenders = []
    @attackers.each do |attacker|
      protect_king = lambda do
        Piece.where(game: self).where.not(color: attacker.color, type: 'King').each do |piece|
          return defenders << piece if piece.valid_move?(attacker.horizontal_position, attacker.vertical_position)
          attacker.obstructed?(@king.horizontal_position, @king.vertical_position)
          $path_to_king.each do |square|
            return defenders << piece if piece.valid_move?(square.first, square.last)
          end
        end
      end
      protect_king.call
    end
    return 'in check & no blockers' if defenders.count < @attackers.count
    true
  end

  def king_cant_move(color)
    king = King.find_by(game: self, color: color)
    x = king.horizontal_position
    y = king.vertical_position
    ((x - 1)..(x + 1)).each do |x_pos|
      ((y - 1)..(y + 1)).each do |y_pos|
        in_bounds = -> { x_pos != 0 && x_pos != 9 && y_pos != 0 && y_pos != 9 }
        return false if in_bounds.call && king.move_into_check?(x_pos, y_pos, x, y) && king.valid_move?(x_pos, y_pos)
      end
    end
  end
end
