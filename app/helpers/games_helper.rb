module GamesHelper
  def render_piece(x, y)
    location = locate_piece(x, y)
    piece_name = "#{location.color}#{location.type}.png" if location.present?
    image_tag(piece_name, class: 'piece-image')
  end

  def locate_piece(x, y)
    @game.pieces.where(horizontal_position: x, vertical_position: y).first
  end

  def promo_modal
    return 'myModal' if white_eighth_rank_pawn || black_eighth_rank_pawn
  end

  def pawn_color
    return 'white' if white_eighth_rank_pawn
    'black'
  end

  private

  def white_eighth_rank_pawn
    @game.pieces.where(type: 'Pawn', vertical_position: 8).first.present?
  end

  def black_eighth_rank_pawn
    @game.pieces.where(type: 'Pawn', vertical_position: 1).first.present?
  end
end
