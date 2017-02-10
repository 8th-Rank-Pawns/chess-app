module GamesHelper
  def render_piece(x, y)
    piece = @game.pieces.where(horizontal_position: x, vertical_position: y).first
    return "#{piece.color} #{piece.type}" if piece
  end
end
