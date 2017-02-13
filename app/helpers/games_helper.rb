module GamesHelper
  def render_piece(x, y)
    piece = locate_piece(x, y)
    piece_name = "#{piece.color}#{piece.type}.png" if piece
    image_tag(piece_name, class: 'piece-image')
  end

  def change_padding(x, y)
    return 'change-padding' if locate_piece(x, y)
  end

  def locate_piece(x, y)
    @game.pieces.where(horizontal_position: x, vertical_position: y).first
  end
end
