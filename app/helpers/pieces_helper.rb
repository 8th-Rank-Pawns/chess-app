module PiecesHelper
  
  def pawn_promo
    return "myModal" if @game.pieces.where(type: 'Pawn', vertical_position: 8).first.present? || @game.pieces.where(type: 'Pawn', vertical_position: 1).first.present? 
  end
end
