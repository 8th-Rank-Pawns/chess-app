class Game < ActiveRecord::Base
  scope :available, -> { where('black_player IS NULL OR white_player IS NULL') }
  has_many :users
  has_many :pieces

  def populate_board!
    @white_king = King.create(horizontal_position: 5, vertical_position: 1, color: 'white', game_id: id)
    @black_king = King.create(horizontal_position: 5, vertical_position: 8, color: 'black', game_id: id)
    [[1, 'white'], [8, 'black']].each do |x|
      Queen.create(horizontal_position: 4, vertical_position: x[0], color: x[1], game_id: id)
      Bishop.create(horizontal_position: 3, vertical_position: x[0], color: x[1], game_id: id)
      Bishop.create(horizontal_position: 6, vertical_position: x[0], color: x[1], game_id: id)
      Knight.create(horizontal_position: 2, vertical_position: x[0], color: x[1], game_id: id)
      Knight.create(horizontal_position: 7, vertical_position: x[0], color: x[1], game_id: id)
      Rook.create(horizontal_position: 1, vertical_position: x[0], color: x[1], game_id: id)
      Rook.create(horizontal_position: 8, vertical_position: x[0], color: x[1], game_id: id)
    end
    count = 1
    while count <= 8
      Pawn.create(horizontal_position: count, vertical_position: 2, color: 'white', game_id: id)
      Pawn.create(horizontal_position: count, vertical_position: 7, color: 'black', game_id: id)
      count += 1
    end
  end

  def white_king_check?
    pieces.where(color: 'black').each do |piece|
      return true if piece.valid_move?(@white_king.horizontal_position, @white_king.vertical_position)
      false
    end
  end

  def black_king_check?
    pieces.where(color: 'white').each do |piece|
      return true if piece.valid_move?(@black_king.horizontal_position, @black_king.vertical_position)
      false
    end
  end
end
