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
    params.require(:piece).permit(:horizontal_position, :vertical_position)
  end
end
