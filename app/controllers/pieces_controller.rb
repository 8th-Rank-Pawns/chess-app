class PiecesController < ApplicationController
  def show
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def update
    @piece = Piece.find(params[:id])
    @piece.move_to!(piece_params)
    @piece.game.check?
    respond_to do |format|
      format.html { redirect_to game_path(@piece.game) }
      format.json { render json: @piece }
    end
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
