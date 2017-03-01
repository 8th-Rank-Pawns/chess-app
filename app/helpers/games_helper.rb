module GamesHelper
  def render_piece(x, y)
    location = locate_piece(x, y)
    piece_name = "#{location.color}#{location.type}.png" if location.present?
    image_tag(piece_name, class: 'piece-image')
  end

  def locate_piece(x, y)
    @game.pieces.where(horizontal_position: x, vertical_position: y).first
  end

  def pawn_promo
    return "myModal" if @game.pieces.where(type: 'Pawn', vertical_position: 8).first.present? || @game.pieces.where(type: 'Pawn', vertical_position: 1).first.present?
  end

end
