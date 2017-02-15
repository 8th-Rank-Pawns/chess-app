class PiecesController < ApplicationController
  def show
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def update
    @piece = Piece.find(params[:id])
    @piece.update_attributes(piece_params)
    redirect_to game_path(@piece.game)
  end

  private

  def piece_params
    params[:piece] = if params.key? :king
                       params.delete :king
                     elsif params.key? :queen
                       params.delete :queen
                     elsif params.key? :rook
                       params.delete :rook
                     elsif params.key? :knight
                       params.delete :knight
                     elsif params.key? :bishop
                       params.delete :bishop
                     else
                       params.delete :pawn
                     end
    params.require(:piece).permit(:horizontal_position, :vertical_position)
  end
end
