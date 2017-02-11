module GamesHelper
  def render_piece(x, y)
    piece = @game.pieces.where(horizontal_position: x, vertical_position: y).first
    piece_name = "#{piece.color}#{piece.type}.png" if piece
    image_tag(piece_name, class: 'piece-image')
  end

  def change_padding(x, y)
    return 'change-padding' if @game.pieces.where(horizontal_position: x, vertical_position: y).first
  end
end
