class PiecesController < ApplicationController
  def show
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def update
    @piece = Piece.find(params[:id])
    @piece.update_attributes(piece_params)
    @piece.move_to!(piece_params)
    @piece.game.check?
    redirect_to game_path(@piece.game)
  end

  private

  def piece_params
    params[:piece] = case @piece.type
                     when 'King'
                       params.delete :king
                     when 'Queen'
                       params.delete :queen
                     when 'Rook'
                       params.delete :rook
                     when 'Knight'
                       params.delete :knight
                     when 'Bishop'
                       params.delete :bishop
                     else
                       params.delete :pawn
                     end
    params.require(:piece).permit(:horizontal_position, :vertical_position)
  end
end
